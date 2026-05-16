const QUANT_NOC = 22
const QUANT_ALPHA_MIN = 0.6
const QUANT_LAMBDA = 0.85
const QUANT_PEOS = 2 / 3

struct QuantParams
    alpha::Vector{Float64}
    taste_female::Vector{Float64}
    tfp::Vector{Float64}
    taste_male::Vector{Float64}
    xi::Float64
    theta::Vector{Float64}
end

struct QuantChoices
    valfuns::Matrix{Float64}
    hours_prime::Matrix{Float64}
    hours_nonprime::Matrix{Float64}
    brw::Matrix{Float64}
    brh::Matrix{Float64}
end

function quantitative_model_dir(root::AbstractString = project_root())
    return joinpath(replication_root(root), "EJ_replicate_model", "Quantitative_Analysis")
end

function load_ces_param(root::AbstractString = project_root())
    path = joinpath(quantitative_model_dir(root), "model_files", "ces_param")
    vals = Float64[]
    for token in split(read(path, String))
        push!(vals, parse(Float64, token))
    end
    if length(vals) != 4 * QUANT_NOC + 3
        error("Expected $(4 * QUANT_NOC + 3) parameters, found $(length(vals)) in $path")
    end
    return vals
end

function unpack_quant_params(paramvec::Vector{Float64})
    n = QUANT_NOC
    return QuantParams(
        paramvec[1:n],
        paramvec[(n + 1):(2n)],
        paramvec[(2n + 1):(3n)],
        paramvec[(3n + 1):(4n)],
        paramvec[4n + 1],
        paramvec[(4n + 2):end],
    )
end

function parse_table8_labor_shares(root::AbstractString = project_root())
    path = joinpath(replication_root(root), "EJ_replicate_model", "latex_tables", "table8.tex")
    shares = Float64[]
    for line in eachline(path)
        m = match(r"^\s*\d+\s*&.*?&\s*([0-9]+\.[0-9]+)\s*&", line)
        if m !== nothing
            push!(shares, parse(Float64, m.captures[1]))
        end
    end
    if length(shares) != QUANT_NOC
        error("Expected 22 labor shares in table8.tex; found $(length(shares))")
    end
    return shares ./ sum(shares)
end

function quant_utility(xvec::AbstractVector, theta, xi, alpha, wage)
    l1, l2 = xvec
    h1 = 0.5 - l1
    h2 = 0.5 - l2
    if l1 <= 0 || l2 <= 0 || h1 <= 0 || h2 <= 0 || alpha < QUANT_ALPHA_MIN
        return -1.0e12
    end
    lstar = l1 + l2 - h1^alpha
    if lstar <= 0 || xi == 0
        return -1.0e12
    end
    care = (h1^xi + h2^xi)^(1 / xi)
    cons = wage * lstar
    if care <= 0 || cons <= 0
        return -1.0e12
    end
    return cons^theta * care^(1 - theta)
end

function solve_quant_choice(theta, xi, alpha, wage)
    objective(x) = -quant_utility(x, theta, xi, alpha, wage)
    nm = Optim.optimize(objective, [0.4, 0.1], NelderMead(),
                        Optim.Options(iterations = 2_000, f_abstol = 1e-10))
    start = clamp.(Optim.minimizer(nm), 1e-5, 0.49999)
    bfgs = Optim.optimize(objective, start, BFGS(),
                          Optim.Options(iterations = 1_000, f_abstol = 1e-10))
    result = Optim.minimum(bfgs) < Optim.minimum(nm) ? bfgs : nm
    l1, l2 = clamp.(Optim.minimizer(result), 1e-5, 0.49999)
    h1 = 0.5 - l1
    h2 = 0.5 - l2
    lstar = l1 + l2 - h1^alpha
    value = quant_utility([l1, l2], theta, xi, alpha, wage)
    return (; l1, l2, h1, h2, lstar, value,
            brw = l1 / (l1 + l2), brh = h1 / (h1 + h2))
end

function quant_all_occ(params::QuantParams, wagevec::Vector{Float64})
    n = QUANT_NOC
    valfuns = zeros(n, 2)
    hours_prime = zeros(n, 2)
    hours_nonprime = zeros(n, 2)
    brw = zeros(n, 2)
    brh = zeros(n, 2)

    for i in 1:n
        for j in 1:2
            choice = solve_quant_choice(params.theta[j], params.xi, params.alpha[i], wagevec[i])
            valfuns[i, j] = choice.value
            hours_prime[i, j] = choice.l1
            hours_nonprime[i, j] = choice.l2
            brw[i, j] = choice.brw
            brh[i, j] = choice.brh
        end
    end
    return QuantChoices(valfuns, hours_prime, hours_nonprime, brw, brh)
end

function quant_wages_iterate(params::QuantParams, lshvec::Vector{Float64};
                             wagevec = ones(QUANT_NOC), tol = 5e-5, maxiter = 100)
    tempwage = copy(wagevec)
    newwages = similar(tempwage)
    clear_diff = Inf
    iter = 1

    while clear_diff > tol && iter <= maxiter
        choices = quant_all_occ(params, tempwage)
        lstar_male = max.(choices.hours_prime[:, 1] .+ choices.hours_nonprime[:, 1] .-
                          (0.5 .- choices.hours_prime[:, 1]) .^ params.alpha, 1e-7)
        lstar_female = max.(choices.hours_prime[:, 2] .+ choices.hours_nonprime[:, 2] .-
                            (0.5 .- choices.hours_prime[:, 2]) .^ params.alpha, 1e-7)

        share_females = params.taste_female .* choices.valfuns[:, 2] ./
                        sum(params.taste_female .* choices.valfuns[:, 2])
        share_males = params.taste_male .* choices.valfuns[:, 1] ./
                     sum(params.taste_male .* choices.valfuns[:, 1])
        massvec = 0.5 .* share_females .+ 0.5 .* share_males
        eff_by_occ = 0.5 .* lstar_female .* share_females .+
                     0.5 .* lstar_male .* share_males
        labor_inputs = params.tfp .* massvec .* eff_by_occ

        n2alpha = lshvec .* (labor_inputs .^ QUANT_PEOS)
        bigsum = sum(n2alpha)
        for j in 1:QUANT_NOC
            newwages[j] = bigsum^(1 / QUANT_PEOS - 1) *
                          lshvec[j] * labor_inputs[j]^(QUANT_PEOS - 1) *
                          params.tfp[j]
        end

        clear_diff = sum(abs.(newwages .- tempwage) ./ tempwage)
        tempwage = (1 - QUANT_LAMBDA) .* newwages .+ QUANT_LAMBDA .* tempwage
        iter += 1
    end
    return tempwage, iter - 1, clear_diff
end

function get_quant_final_data(params::QuantParams, wagevec::Vector{Float64})
    choices = quant_all_occ(params, wagevec)
    share_f_raw = params.taste_female .* choices.valfuns[:, 2] ./
                  sum(params.taste_female .* choices.valfuns[:, 2])
    share_m_raw = params.taste_male .* choices.valfuns[:, 1] ./
                  sum(params.taste_male .* choices.valfuns[:, 1])
    massvec = 0.5 .* share_f_raw .+ 0.5 .* share_m_raw
    sf = 0.5 .* share_f_raw ./ massvec

    lstar_male = choices.hours_prime[:, 1] .+ choices.hours_nonprime[:, 1] .-
                 (0.5 .- choices.hours_prime[:, 1]) .^ params.alpha
    lstar_female = choices.hours_prime[:, 2] .+ choices.hours_nonprime[:, 2] .-
                   (0.5 .- choices.hours_prime[:, 2]) .^ params.alpha
    hours_male = choices.hours_prime[:, 1] .+ choices.hours_nonprime[:, 1]
    hours_female = choices.hours_prime[:, 2] .+ choices.hours_nonprime[:, 2]
    earn_male = lstar_male .* wagevec
    earn_female = lstar_female .* wagevec
    earnph_male = earn_male ./ hours_male
    earnph_female = earn_female ./ hours_female
    gender_gap_occ = earnph_male ./ earnph_female

    brw_occ_raw = sf .* choices.brw[:, 2] .+ (1 .- sf) .* choices.brw[:, 1]
    brw_occ = (brw_occ_raw .- mean(brw_occ_raw)) ./ std(brw_occ_raw)
    earnph_occ = sf .* earnph_female .+ (1 .- sf) .* earnph_male

    all_male_earnph = sum(earnph_male .* massvec .* (1 .- sf)) / 0.5
    all_female_earnph = sum(earnph_female .* massvec .* sf) / 0.5
    aggregate_gender_gap = all_male_earnph / all_female_earnph

    return (; choices, sf, massvec, lstar_male, lstar_female, hours_male,
            hours_female, earn_male, earn_female, earnph_male, earnph_female,
            gender_gap_occ, brw_occ, brw_occ_raw, earnph_occ,
            aggregate_gender_gap, all_male_earnph, all_female_earnph)
end

function gender_gap_decomp_julia(earnph_female, earnph_male, massvec, sf)
    alpha_m = (1 .- sf) .* massvec ./ 0.5
    alpha_f = sf .* massvec ./ 0.5
    total = sum(alpha_m .* earnph_male) / sum(alpha_f .* earnph_female)
    across = sum(alpha_m .* earnph_female) / sum(alpha_f .* earnph_female)
    within = sum(alpha_m .* earnph_male) / sum(alpha_m .* earnph_female)
    return (; total = log(total), across = log(across), within = log(within))
end

function quant_ols_coef(y::Vector{Float64}, X::Matrix{Float64})
    return X \ y
end

function quant_earnph_regression(data)
    y = log.(vcat(data.earnph_male, data.earnph_female))
    female = vcat(zeros(QUANT_NOC), ones(QUANT_NOC))
    brw = vcat(data.brw_occ, data.brw_occ)
    X = hcat(ones(2QUANT_NOC), brw, female, female .* brw)
    coef = quant_ols_coef(y, X)
    return DataFrame(term = [:intercept, :brw, :female, :femaleXbrw], estimate = coef)
end

function run_quantitative_baseline_and_counterfactual(; root::AbstractString = project_root())
    lshvec = parse_table8_labor_shares(root)
    paramvec = load_ces_param(root)
    baseline_params = unpack_quant_params(paramvec)

    base_wages, base_iters, base_diff = quant_wages_iterate(baseline_params, lshvec)
    baseline = get_quant_final_data(baseline_params, base_wages)
    baseline_decomp = gender_gap_decomp_julia(baseline.earnph_female, baseline.earnph_male,
                                              baseline.massvec, baseline.sf)

    counter_vec = copy(paramvec)
    counter_vec[1:QUANT_NOC] .= paramvec[11]
    counter_params = unpack_quant_params(counter_vec)
    counter_wages, counter_iters, counter_diff = quant_wages_iterate(counter_params, lshvec;
                                                                     wagevec = base_wages)
    counter = get_quant_final_data(counter_params, counter_wages)
    counter_decomp = gender_gap_decomp_julia(counter.earnph_female, counter.earnph_male,
                                             counter.massvec, counter.sf)

    outdir = table_output_dir(root)
    mkpath(outdir)
    summary = DataFrame(
        scenario = ["baseline", "same_alpha_healthcare_support"],
        alpha_rule = ["estimated occupation-specific alpha", "all alpha set to occupation 11 alpha"],
        aggregate_gender_gap_percent = [(baseline.aggregate_gender_gap - 1) * 100,
                                        (counter.aggregate_gender_gap - 1) * 100],
        decomp_total_log = [baseline_decomp.total, counter_decomp.total],
        decomp_across_log = [baseline_decomp.across, counter_decomp.across],
        decomp_within_log = [baseline_decomp.within, counter_decomp.within],
        wage_iterations = [base_iters, counter_iters],
        wage_final_diff = [base_diff, counter_diff],
    )
    CSV.write(joinpath(outdir, "counterfactual_5_3_2_summary.csv"), summary)
    CSV.write(joinpath(outdir, "counterfactual_5_3_2_baseline_regression.csv"),
              quant_earnph_regression(baseline))
    CSV.write(joinpath(outdir, "counterfactual_5_3_2_counter_regression.csv"),
              quant_earnph_regression(counter))

    log = """
    Counterfactual 5.3.2 Julia port

    This ports the quantitative model in:
    replication-package/Codes_CubasJuhnSilos/EJ_replicate_model/Quantitative_Analysis/model_files/main_ge.R

    Implemented experiment:
    experiment == 1, Same alpha as healthcare support.

    Data availability note:
    The replication package in this repository does not include the
    Quantitative_Analysis/data/*.txt files used by main_ge.R. The Julia port
    uses estimated parameters from model_files/ces_param and parses the labor
    shares from latex_tables/table8.tex. This is enough to solve the baseline
    and counterfactual equilibria, but it does not recompute the original model
    fit statistic against all calibration moments.
    """
    mkpath(joinpath(root, "output", "logs"))
    write(joinpath(root, "output", "logs", "counterfactual_5_3_2_note.txt"), log)

    return (; status = :ok, summary, baseline_regression = quant_earnph_regression(baseline),
            counter_regression = quant_earnph_regression(counter),
            summary_path = joinpath(outdir, "counterfactual_5_3_2_summary.csv"))
end
