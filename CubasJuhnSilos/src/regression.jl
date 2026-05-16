function as_float_vector(x)
    return [ismissing(v) ? missing : Float64(v) for v in x]
end

function complete_cases(df::DataFrame, cols::Vector{Symbol})
    keep = trues(nrow(df))
    for col in cols
        keep .&= .!ismissing.(df[!, col])
    end
    return df[keep, :]
end

function first_nonmissing(x)
    for v in x
        if !ismissing(v)
            return v
        end
    end
    return missing
end

function weighted_mean(x, w)
    ok = .!ismissing.(x) .& .!ismissing.(w)
    return sum(Float64.(x[ok]) .* Float64.(w[ok])) / sum(Float64.(w[ok]))
end

function add_dummy_columns!(Xcols, names, df::DataFrame, var::Symbol)
    levels = sort(unique(skipmissing(df[!, var])))
    if length(levels) <= 1
        return
    end
    for level in levels[2:end]
        push!(Xcols, Float64.(df[!, var] .== level))
        push!(names, Symbol("$(var)_$(level)"))
    end
end

function model_matrix(df::DataFrame; continuous::Vector{Symbol}, categorical::Vector{Symbol})
    Xcols = Vector{Vector{Float64}}()
    names = Symbol[]
    push!(Xcols, ones(nrow(df)))
    push!(names, :intercept)
    for var in continuous
        push!(Xcols, Float64.(df[!, var]))
        push!(names, var)
    end
    for var in categorical
        add_dummy_columns!(Xcols, names, df, var)
    end
    return hcat(Xcols...), names
end

function wls(y::Vector{Float64}, X::Matrix{Float64}, w::Vector{Float64}; cluster = nothing)
    sw = sqrt.(w)
    Xw = X .* sw
    yw = y .* sw
    beta = Xw \ yw
    residuals = y - X * beta
    bread = inv(X' * Diagonal(w) * X)

    if cluster === nothing
        n, k = size(X)
        sigma2 = sum(w .* residuals .^ 2) / max(n - k, 1)
        vcov = sigma2 * bread
    else
        meat = zeros(size(X, 2), size(X, 2))
        for g in unique(cluster)
            idx = findall(==(g), cluster)
            Xg = X[idx, :]
            ug = residuals[idx]
            wg = w[idx]
            score = Xg' * (wg .* ug)
            meat .+= score * score'
        end
        n, k = size(X)
        gcount = length(unique(cluster))
        scale = (gcount / max(gcount - 1, 1)) * ((n - 1) / max(n - k, 1))
        vcov = scale * bread * meat * bread
    end

    se = sqrt.(max.(diag(vcov), 0.0))
    return beta, se
end

function fit_wls_table(df::DataFrame, outcome::Symbol; continuous::Vector{Symbol},
                       categorical::Vector{Symbol}, weight::Symbol, cluster::Union{Nothing, Symbol} = nothing)
    cols = unique(vcat([outcome, weight], continuous, categorical, cluster === nothing ? Symbol[] : [cluster]))
    d = complete_cases(df, cols)
    y = Float64.(d[!, outcome])
    X, names = model_matrix(d, continuous = continuous, categorical = categorical)
    w = Float64.(d[!, weight])
    cl = cluster === nothing ? nothing : d[!, cluster]
    beta, se = wls(y, X, w, cluster = cl)
    return DataFrame(term = names, estimate = beta, se = se, nobs = nrow(d))
end

function read_dta(path::AbstractString)
    return DataFrame(load(path))
end
