function source_file_table12(root)
    return joinpath(replication_root(root), "EJ_replicate", "document_data_new",
                    "document_dta", "5_data_#5.dta")
end

function source_files_table6(root)
    base = replication_root(root)
    return (
        reg = joinpath(base, "EJ_replicate", "document_data_new", "document_dta",
                       "6_regression data", "6_b_reg.dta"),
        onet = joinpath(base, "EJ_replicate", "table6-7", "ONET_563b.dta"),
        bratio = joinpath(base, "EJ_replicate", "table6-7", "bratio_563all.dta"),
    )
end

function missing_inputs(paths)
    return [path for path in paths if !isfile(path)]
end

function write_missing_log(root, name, paths)
    msg = """
    $name cannot be produced from the `.dta` route yet.

    Missing input files:
    $(join(paths, "\n    "))

    After you produce these files from Stata, rerun the Julia command.
    """
    mkpath(joinpath(root, "output", "logs"))
    write(joinpath(root, "output", "logs", "$(name)_missing_dta.txt"), msg)
    return (; status = :needs_stata_intermediate_data, missing = paths, message = msg)
end

function prepare_table12_data(df::DataFrame)
    d = copy(df)
    d = d[.!ismissing.(d.id), :]
    d.married = d.pemaritl .== 1
    d.child = d.trohhchild .== 1
    d.fulltime = d.trdpftpt .== 1
    d = d[(d.teage .>= 18) .& (d.teage .<= 65) .& d.fulltime .& d.married .& d.child, :]

    d.female = Float64.(d.tesex .== 2)
    d.teage2 = Float64.(d.teage) .^ 2
    d.teage3 = Float64.(d.teage) .^ 3
    d.teage4 = Float64.(d.teage) .^ 4

    keepcols = [:year, :id, :tudiaryday, :tufnwgtp, :teage, :teage2, :teage3,
                :teage4, :peeduca, :ptdtrace, :tehruslt, :female]
    g = groupby(d, [:year, :id])
    out = combine(g,
        :work => (x -> sum(skipmissing(x))) => :totwork,
        :householdcare => (x -> sum(skipmissing(x))) => :tothhcare,
        [col => first_nonmissing => col for col in keepcols]...,
    )
    out.weekday = (out.tudiaryday .> 1) .& (out.tudiaryday .< 7)
    return out
end

function extract_term(model::DataFrame, term::Symbol)
    row = model[model.term .== term, :]
    if nrow(row) == 0
        return (estimate = missing, se = missing, nobs = first(model.nobs))
    end
    return (estimate = row.estimate[1], se = row.se[1], nobs = row.nobs[1])
end

function table12_models(df::DataFrame, outcome::Symbol)
    weekday = df[df.weekday .== true, :]
    weekend = df[df.weekday .== false, :]
    weekday_lt50 = weekday[weekday.tehruslt .< 50, :]

    return [
        fit_wls_table(weekday, outcome, continuous = [:female], categorical = Symbol[],
                      weight = :tufnwgtp),
        fit_wls_table(weekend, outcome, continuous = [:female], categorical = Symbol[],
                      weight = :tufnwgtp),
        fit_wls_table(weekday, outcome, continuous = [:female],
                      categorical = [:tudiaryday, :year], weight = :tufnwgtp),
        fit_wls_table(weekday, outcome,
                      continuous = [:female, :teage, :teage2, :teage3, :teage4],
                      categorical = [:tudiaryday, :year, :peeduca, :ptdtrace],
                      weight = :tufnwgtp),
        fit_wls_table(weekday, outcome,
                      continuous = [:female, :teage, :teage2, :teage3, :teage4, :tehruslt],
                      categorical = [:tudiaryday, :year, :peeduca, :ptdtrace],
                      weight = :tufnwgtp),
        fit_wls_table(weekday_lt50, outcome,
                      continuous = [:female, :teage, :teage2, :teage3, :teage4, :tehruslt],
                      categorical = [:tudiaryday, :year, :peeduca, :ptdtrace],
                      weight = :tufnwgtp),
    ]
end

function summarize_table12(df::DataFrame, outcome::Symbol)
    models = table12_models(df, outcome)
    rows = DataFrame(model = Int[], estimate = Float64[], se = Float64[], nobs = Int[])
    for (i, model) in enumerate(models)
        term = extract_term(model, :female)
        push!(rows, (i, term.estimate, term.se, term.nobs))
    end
    return rows
end

function run_table1_table2_from_dta(; root::AbstractString = project_root())
    path = source_file_table12(root)
    missing = missing_inputs([path])
    if !isempty(missing)
        return write_missing_log(root, "tables1_2", missing)
    end

    df = prepare_table12_data(read_dta(path))
    outdir = table_output_dir(root)
    mkpath(outdir)
    table1 = summarize_table12(df, :totwork)
    table2 = summarize_table12(df, :tothhcare)
    CSV.write(joinpath(outdir, "table1_from_dta.csv"), table1)
    CSV.write(joinpath(outdir, "table2_from_dta.csv"), table2)

    means = DataFrame(
        statistic = ["weekday_male_work", "weekday_female_work", "weekend_male_work",
                     "weekend_female_work", "weekday_male_hhcare", "weekday_female_hhcare",
                     "weekend_male_hhcare", "weekend_female_hhcare"],
        value = [
            weighted_mean(df[(df.weekday .== true) .& (df.female .== 0), :totwork],
                          df[(df.weekday .== true) .& (df.female .== 0), :tufnwgtp]),
            weighted_mean(df[(df.weekday .== true) .& (df.female .== 1), :totwork],
                          df[(df.weekday .== true) .& (df.female .== 1), :tufnwgtp]),
            weighted_mean(df[(df.weekday .== false) .& (df.female .== 0), :totwork],
                          df[(df.weekday .== false) .& (df.female .== 0), :tufnwgtp]),
            weighted_mean(df[(df.weekday .== false) .& (df.female .== 1), :totwork],
                          df[(df.weekday .== false) .& (df.female .== 1), :tufnwgtp]),
            weighted_mean(df[(df.weekday .== true) .& (df.female .== 0), :tothhcare],
                          df[(df.weekday .== true) .& (df.female .== 0), :tufnwgtp]),
            weighted_mean(df[(df.weekday .== true) .& (df.female .== 1), :tothhcare],
                          df[(df.weekday .== true) .& (df.female .== 1), :tufnwgtp]),
            weighted_mean(df[(df.weekday .== false) .& (df.female .== 0), :tothhcare],
                          df[(df.weekday .== false) .& (df.female .== 0), :tufnwgtp]),
            weighted_mean(df[(df.weekday .== false) .& (df.female .== 1), :tothhcare],
                          df[(df.weekday .== false) .& (df.female .== 1), :tufnwgtp]),
        ],
    )
    CSV.write(joinpath(outdir, "tables1_2_weighted_means_from_dta.csv"), means)
    return (; status = :ok, table1, table2, means)
end

function standardize_skipmissing(x)
    vals = collect(skipmissing(x))
    mu = mean(vals)
    sig = std(vals)
    return [ismissing(v) ? missing : (Float64(v) - mu) / sig for v in x]
end

function leftjoin_if_present(left::DataFrame, right::DataFrame, on::Symbol)
    return leftjoin(left, right, on = on, makeunique = true)
end

function prepare_table6_data(regdf::DataFrame, onetdf::DataFrame, bratiodf::DataFrame)
    d = leftjoin_if_present(regdf, onetdf, :occ_563)
    d = leftjoin_if_present(d, bratiodf, :occ_563)

    for var in [:social, :abstract, :manual, :routine]
        if var in propertynames(d)
            d[!, Symbol("$(var)_563")] = standardize_skipmissing(d[!, var])
        end
    end

    d = d[(d.prtage .>= 18) .& (d.prtage .<= 65) .&
          (d.prhrusl .>= 3) .& (d.prhrusl .<= 6) .& (d.prernwa .> 0), :]
    d.lprernwa = log.(Float64.(d.prernwa))
    d.lpehrusl1 = log.(Float64.(d.pehrusl1))
    d.prtage2 = Float64.(d.prtage) .^ 2
    d.prtage3 = Float64.(d.prtage) .^ 3
    d.prtage4 = Float64.(d.prtage) .^ 4
    d.female = Float64.(d.pesex .== 2)
    d.femaleXbratio_563 = d.female .* Float64.(d.bratio_563)
    return d
end

function table6_sample(df::DataFrame, sample::Symbol)
    if sample == :all
        return df
    elseif sample == :single_no_children
        return df[(df.pemaritl .!= 1) .& (df.pemaritl .!= 2) .& (df.prnmchld .< 1), :]
    elseif sample == :married_with_children
        return df[((df.pemaritl .== 1) .| (df.pemaritl .== 2)) .& (df.prnmchld .> 0), :]
    else
        error("Unknown sample: $sample")
    end
end

function run_table6_spec(df::DataFrame; extra_continuous::Vector{Symbol})
    continuous = vcat([:female, :bratio_563, :femaleXbratio_563,
                       :prtage, :prtage2, :prtage3, :prtage4, :lpehrusl1],
                      extra_continuous)
    categorical = [:peeduca, :ptdtrace, :year]
    return fit_wls_table(df, :lprernwa, continuous = continuous, categorical = categorical,
                         weight = :tubwgt, cluster = :occ_563)
end

function summarize_table6(df::DataFrame)
    samples = [:all, :single_no_children, :married_with_children]
    specs = [
        Symbol[],
        [:avg_educ563],
        [:avg_educ563, :male_overwork563],
        [:avg_educ563, :male_overwork563, :social_563, :abstract_563, :manual_563, :routine_563],
    ]

    rows = DataFrame(sample = Symbol[], model = Int[], term = Symbol[],
                     estimate = Float64[], se = Float64[], nobs = Int[])
    for sample in samples
        sdf = table6_sample(df, sample)
        for (i, extra) in enumerate(specs)
            model = run_table6_spec(sdf, extra_continuous = extra)
            for term in [:female, :femaleXbratio_563, :bratio_563]
                val = extract_term(model, term)
                push!(rows, (sample, i, term, val.estimate, val.se, val.nobs))
            end
        end
    end
    return rows
end

function run_table6_from_dta(; root::AbstractString = project_root())
    paths = source_files_table6(root)
    missing = missing_inputs([paths.reg, paths.onet, paths.bratio])
    if !isempty(missing)
        return write_missing_log(root, "table6", missing)
    end

    df = prepare_table6_data(read_dta(paths.reg), read_dta(paths.onet), read_dta(paths.bratio))
    table6 = summarize_table6(df)
    outdir = table_output_dir(root)
    mkpath(outdir)
    CSV.write(joinpath(outdir, "table6_from_dta.csv"), table6)
    return (; status = :ok, table6)
end

function run_table1_table2_from_raw(; root::AbstractString = project_root())
    msg = """
    Raw Julia route for Tables 1 and 2.

    The Stata path constructs `5_data_#5.dta` via:
    1. raw ATUS fixed-width files -> Stata_Raw_Data/*.dta
    2. document_dta/2_1 through 2_4
    3. document_dta/3_br_cr/3a-3j
    4. document_dta/4_spouse.do
    5. document_dta/5_data_5.do

    The Julia final-table code is already implemented in
    `run_table1_table2_from_dta()`. The remaining raw-port work is to replace
    Stata's fixed-width import and merge chain with Julia code that produces
    the same columns as `5_data_#5.dta`.
    """
    mkpath(joinpath(root, "output", "logs"))
    write(joinpath(root, "output", "logs", "tables1_2_raw_port_plan.txt"), msg)
    return (; status = :raw_port_scaffolded, message = msg)
end

function run_table6_from_raw(; root::AbstractString = project_root())
    msg = """
    Raw Julia route for Table 6.

    Table 6 builds on `6_b_reg.dta`, `ONET_563b.dta`, and `bratio_563all.dta`.
    The Julia final-regression code is implemented in `run_table6_from_dta()`.
    The remaining raw-port work is to port:
    - document_dta/6_regression data/6_a.do
    - 6.2_ratios/ratios_94_563_22.do
    - 6.4_avgeduc/6.4_avg_educ.do
    - 6.5_male_overwork/6.5_male_overwork.do
    - table6-7/regs_ONET_563.do
    """
    mkpath(joinpath(root, "output", "logs"))
    write(joinpath(root, "output", "logs", "table6_raw_port_plan.txt"), msg)
    return (; status = :raw_port_scaffolded, message = msg)
end

function run_table1_table2(; root::AbstractString = project_root(), source::Symbol = :dta)
    if source == :dta
        return run_table1_table2_from_dta(root = root)
    elseif source == :raw
        return run_table1_table2_from_raw(root = root)
    else
        error("source must be :dta or :raw")
    end
end

function run_table6(; root::AbstractString = project_root(), source::Symbol = :dta)
    if source == :dta
        return run_table6_from_dta(root = root)
    elseif source == :raw
        return run_table6_from_raw(root = root)
    else
        error("source must be :dta or :raw")
    end
end
