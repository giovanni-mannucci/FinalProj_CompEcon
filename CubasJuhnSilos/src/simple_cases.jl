const T1_SIMPLE = 0.5
const T2_SIMPLE = 0.5
const ALPHA_MIN_SIMPLE = 0.7

struct SimpleChoice
    l1::Float64
    l2::Float64
    utility::Float64
    effective_labor::Float64
    raw_labor::Float64
    bunching_ratio::Float64
    earnings::Float64
end

function utility_no_tastes(x::AbstractVector, wage, alpha, nu, weight)
    l1, l2 = x
    h1 = 0.5 - l1
    h2 = 0.5 - l2
    if l1 < 0 || l2 < 0 || h1 < 0 || h2 < 0
        return -1.0e10
    end
    home = (h1^nu + h2^nu)^(1 / nu)
    effective_labor = l1 + l2 - h1^alpha
    c = wage * effective_labor
    if home <= 0 || c <= 0 || effective_labor <= 0
        return -1.0e10
    end
    return c^weight * home^(1 - weight)
end

function solve_choice_no_tastes(wage, alpha, nu, weight)
    objective(x) = -utility_no_tastes(x, wage, alpha, nu, weight)
    result = Optim.optimize(objective, [0.2, 0.2], NelderMead(),
                            Optim.Options(iterations = 2_000, x_abstol = 1e-12,
                                          f_abstol = 1e-12))
    l1, l2 = Optim.minimizer(result)
    effective_labor = l1 + l2 - (0.5 - l1)^alpha
    earnings = effective_labor * wage
    return SimpleChoice(l1, l2, -Optim.minimum(result), effective_labor,
                        l1 + l2, l1 / (l1 + l2), earnings)
end

function one_gender_residual!(fvec, x, alphavec, labor_shares, nu, weight)
    shares = [x[1], 1 - x[1]]
    wagevec = [x[2], x[3]]
    if minimum(x) <= 0 || minimum(shares) <= 0
        fvec .= 10_000.0
        return fvec
    end

    choices = [solve_choice_no_tastes(wagevec[i], alphavec[i], nu, weight) for i in 1:2]
    eff = [choice.effective_labor for choice in choices]
    val = [choice.utility for choice in choices]

    fvec[1] = wagevec[1] -
        labor_shares[1] * (shares[1] * eff[1])^(labor_shares[1] - 1) *
        (shares[2] * eff[2])^labor_shares[2]
    fvec[2] = wagevec[2] -
        labor_shares[2] * (shares[1] * eff[1])^labor_shares[1] *
        (shares[2] * eff[2])^(labor_shares[2] - 1)
    fvec[3] = val[1] - val[2]
    return fvec
end

function solve_no_gender_case()
    alphavec = [0.8, 2.8]
    labor_shares = [0.5, 0.5]
    nu = 0.6
    weight = 0.8
    result = nlsolve((f, x) -> one_gender_residual!(f, x, alphavec, labor_shares, nu, weight),
                     [0.2, 1.5, 1.5], xtol = 1e-10, ftol = 1e-10)

    x = result.zero
    shares = [x[1], 1 - x[1]]
    wagevec = [x[2], x[3]]
    choices = [solve_choice_no_tastes(wagevec[i], alphavec[i], nu, weight) for i in 1:2]

    return DataFrame(
        statistic = ["Share of Workers", "Ratio 8to5", "Earnings",
                     "Rawlabor by occ", "Eff Labor by Occ"],
        V1 = [shares[1], choices[1].bunching_ratio, choices[1].earnings,
              choices[1].raw_labor, choices[1].effective_labor],
        V2 = [shares[2], choices[2].bunching_ratio, choices[2].earnings,
              choices[2].raw_labor, choices[2].effective_labor],
    )
end

function two_gender_residual!(fvec, x, alphavec, labor_shares, nu_f, nu_m, weight_f, weight_m)
    shares = [x[1], 1 - x[1]]
    wagevec = [x[2], x[3]]
    if minimum(x) <= 0 || minimum(shares) <= 0
        fvec .= 10_000.0
        return fvec
    end

    male = [solve_choice_no_tastes(wagevec[i], alphavec[i], nu_m, weight_m) for i in 1:2]
    female = [solve_choice_no_tastes(wagevec[i], alphavec[i], nu_f, weight_f) for i in 1:2]

    share_m = [min(shares[1], 0.5), 0.0]
    share_m[2] = 0.5 - share_m[1]
    share_f = [shares[1] - share_m[1], shares[2] - share_m[2]]

    labor_inputs = share_f .* [c.effective_labor for c in female] .+
                   share_m .* [c.effective_labor for c in male]

    fvec[1] = wagevec[1] -
        labor_shares[1] * labor_inputs[1]^(labor_shares[1] - 1) *
        labor_inputs[2]^labor_shares[2]
    fvec[2] = wagevec[2] -
        labor_shares[2] * labor_inputs[1]^labor_shares[1] *
        labor_inputs[2]^(labor_shares[2] - 1)
    fvec[3] = male[1].utility - male[2].utility
    return fvec
end

function solve_gender_diff_nu_case()
    alphavec = [0.8, 2.8]
    labor_shares = [0.5, 0.5]
    nu_f, nu_m = 0.6, 0.6
    weight_f, weight_m = 0.7, 0.9

    result = nlsolve((f, x) -> two_gender_residual!(f, x, alphavec, labor_shares,
                                                    nu_f, nu_m, weight_f, weight_m),
                     [0.2, 0.5, 0.5], xtol = 1e-10, ftol = 1e-10)
    x = result.zero
    shares = [x[1], 1 - x[1]]
    wagevec = [x[2], x[3]]

    male = [solve_choice_no_tastes(wagevec[i], alphavec[i], nu_m, weight_m) for i in 1:2]
    female = [solve_choice_no_tastes(wagevec[i], alphavec[i], nu_f, weight_f) for i in 1:2]

    share_m = [min(shares[1], 0.5), 0.0]
    share_m[2] = 0.5 - share_m[1]
    share_f = [shares[1] - share_m[1], shares[2] - share_m[2]]

    male_hourly = [male[i].earnings / male[i].raw_labor for i in 1:2]
    female_hourly = [female[i].earnings / female[i].raw_labor for i in 1:2]
    gender_gap = sum(male_hourly .* share_m) / sum(female_hourly .* share_f)
    gender_gap_occ2 = male_hourly[2] / female_hourly[2]

    brw_by_occ = [
        (share_m[1] * male[1].bunching_ratio + share_f[1] * female[1].bunching_ratio) / shares[1],
        (share_m[2] * male[2].bunching_ratio + share_f[2] * female[2].bunching_ratio) / shares[2],
    ]
    eff_by_occ = ([c.effective_labor for c in male] .* share_m .+
                  [c.effective_labor for c in female] .* share_f) ./ shares
    raw_by_occ = ([c.raw_labor for c in male] .* share_m .+
                  [c.raw_labor for c in female] .* share_f) ./ shares

    return DataFrame(
        statistic = ["Gender Gap", "Gender Gap Occ2", "Share of Workers", "Ratio 8to5",
                     "Earnings", "Rawlabor by occ", "Eff Labor by Occ", "Share females"],
        V1 = [gender_gap, gender_gap_occ2, shares[1], brw_by_occ[1],
              eff_by_occ[1] * wagevec[1], raw_by_occ[1], eff_by_occ[1], share_f[1] / shares[1]],
        V2 = [gender_gap, gender_gap_occ2, shares[2], brw_by_occ[2],
              eff_by_occ[2] * wagevec[2], raw_by_occ[2], eff_by_occ[2], share_f[2] / shares[2]],
    )
end

function utility_tastes(x::AbstractVector, nu, rho, alpha, wage)
    l1, l2 = x
    h1 = T1_SIMPLE - l1
    h2 = T2_SIMPLE - l2
    if l1 <= 0 || l2 <= 0 || h1 <= 0 || h2 <= 0 || alpha < ALPHA_MIN_SIMPLE
        return -1.0e10
    end
    effective_labor = l1 + l2 - h1^alpha
    if effective_labor <= 0
        return -1.0e10
    end
    care = (h1^rho + h2^rho)^(1 / rho)
    cons = wage * effective_labor
    return cons^nu * care^(1 - nu)
end

function solve_choice_tastes(wage, alpha, nu, rho)
    objective(x) = -utility_tastes(x, nu, rho, alpha, wage)
    first = Optim.optimize(objective, [0.8 * T1_SIMPLE, 0.1], NelderMead(),
                           Optim.Options(iterations = 2_000))
    second = Optim.optimize(objective, Optim.minimizer(first), BFGS(),
                            Optim.Options(iterations = 2_000))
    result = Optim.minimum(second) < Optim.minimum(first) ? second : first
    l1, l2 = Optim.minimizer(result)
    effective_labor = l1 + l2 - (T1_SIMPLE - l1)^alpha
    earnings = effective_labor * wage
    return SimpleChoice(l1, l2, -Optim.minimum(result), effective_labor,
                        l1 + l2, l1 / (l1 + l2), earnings)
end

function all_occ_tastes(taste_param, wagevec; alpha_vec = [0.8, 2.8],
                        nu_vec = [0.9, 0.7], rho = 0.6)
    male = [solve_choice_tastes(wagevec[i], alpha_vec[i], nu_vec[1], rho) for i in 1:2]
    female = [solve_choice_tastes(wagevec[i], alpha_vec[i], nu_vec[2], rho) for i in 1:2]
    return (; male, female)
end

function wages_iterate_tastes(taste_param, wagevec; lshvec = [0.5, 0.5],
                              lambda = 0.85, alpha_vec = [0.8, 2.8],
                              nu_vec = [0.9, 0.7], rho = 0.6)
    tempwage = copy(wagevec)
    newwages = copy(wagevec)
    clear_diff = 10.0
    iter = 1
    while clear_diff > 0.005 && iter <= 100
        choices = all_occ_tastes(taste_param, tempwage; alpha_vec, nu_vec, rho)
        val_m = [c.utility for c in choices.male]
        val_f = [c.utility for c in choices.female]
        eff_m = [c.effective_labor for c in choices.male]
        eff_f = [c.effective_labor for c in choices.female]

        share_females = taste_param .* val_f ./ sum(taste_param .* val_f)
        share_males = val_m ./ sum(val_m)
        massvec = 0.5 .* share_females .+ 0.5 .* share_males
        eff_by_occ = eff_f .* share_females .+ eff_m .* share_males
        labor_inputs = massvec .* eff_by_occ

        n2alpha = labor_inputs .^ lshvec
        for j in 1:2
            other = j == 1 ? 2 : 1
            newwages[j] = lshvec[j] * labor_inputs[j]^(lshvec[j] - 1) * n2alpha[other]
        end
        clear_diff = sum(abs.(newwages .- tempwage) ./ tempwage)
        tempwage = (1 - lambda) .* newwages .+ lambda .* tempwage
        iter += 1
    end
    return tempwage
end

function final_model_data_tastes(taste_param, wagevec)
    wagevec = wages_iterate_tastes(taste_param, wagevec)
    choices = all_occ_tastes(taste_param, wagevec)

    val_m = [c.utility for c in choices.male]
    val_f = [c.utility for c in choices.female]
    share_females_raw = taste_param .* val_f ./ sum(taste_param .* val_f)
    share_males_raw = val_m ./ sum(val_m)
    massvec = 0.5 .* share_females_raw .+ 0.5 .* share_males_raw
    sf = 0.5 .* share_females_raw ./ massvec

    brw_occ = sf .* [c.bunching_ratio for c in choices.female] .+
              (1 .- sf) .* [c.bunching_ratio for c in choices.male]
    earn_male = [c.earnings for c in choices.male]
    earn_female = [c.earnings for c in choices.female]
    hourly_male = earn_male ./ [c.raw_labor for c in choices.male]
    hourly_female = earn_female ./ [c.raw_labor for c in choices.female]
    gender_gap_occ = hourly_male ./ hourly_female
    aggregate_gender_gap = sum(massvec .* gender_gap_occ)
    earn_occ = sf .* earn_female .+ (1 .- sf) .* earn_male
    # Match the original R output, which reports raw labor using gender-wide
    # average hours rather than occupation-specific hours in this panel.
    raw_female_mean = mean([c.raw_labor for c in choices.female])
    raw_male_mean = mean([c.raw_labor for c in choices.male])
    raw_occ = sf .* raw_female_mean .+ (1 .- sf) .* raw_male_mean
    eff_occ = sf .* [c.effective_labor for c in choices.female] .+
              (1 .- sf) .* [c.effective_labor for c in choices.male]

    return (; aggregate_gender_gap, gender_gap_occ, brw_occ, sf, massvec,
            earn_occ, raw_occ, eff_occ)
end

function solve_tastes_case()
    target_share_fem = [0.5, 0.5]
    objective(log_taste) = begin
        taste_param = exp.(log_taste)
        data = final_model_data_tastes(taste_param, [1.0, 1.0])
        sum(((data.sf .- target_share_fem) ./ target_share_fem) .^ 2)
    end
    result = Optim.optimize(objective, log.([5.0, 5.0]), NelderMead(),
                            Optim.Options(iterations = 15_000, x_abstol = 1e-8,
                                          f_abstol = 1e-8))
    taste_param = exp.(Optim.minimizer(result))
    data = final_model_data_tastes(taste_param, [1.0, 1.0])

    return DataFrame(
        statistic = ["Agg Gender Gap", "Gender Gap by Occ", "Ratio 8to5",
                     "Share Females", "Percent Workers", "Earnings",
                     "Raw Labor", "Eff Labor"],
        V1 = [data.aggregate_gender_gap, data.gender_gap_occ[1], data.brw_occ[1],
              data.sf[1], data.massvec[1], data.earn_occ[1], data.raw_occ[1],
              data.eff_occ[1]],
        V2 = [data.aggregate_gender_gap, data.gender_gap_occ[2], data.brw_occ[2],
              data.sf[2], data.massvec[2], data.earn_occ[2], data.raw_occ[2],
              data.eff_occ[2]],
    )
end

function write_table5_tex(path::AbstractString, no_gender::DataFrame,
                          diff_nu::DataFrame, tastes::DataFrame)
    open(path, "w") do io
        println(io, "\\begin{tabular}{lcc}")
        println(io, "\\hline")
        println(io, "Statistic & Occupation 1 & Occupation 2 \\\\")
        println(io, "\\hline")
        for (title, df) in [
            ("Panel A: No Gender Differences", no_gender),
            ("Panel B: Gender-Specific \$\\nu\$", diff_nu),
            ("Panel C: Gender-Specific \$\\nu\$ and Tastes", tastes),
        ]
            println(io, "\\multicolumn{3}{l}{$title} \\\\")
            for row in eachrow(df)
                println(io, "$(row.statistic) & $(round(row.V1, digits=3)) & $(round(row.V2, digits=3)) \\\\")
            end
            println(io, "\\hline")
        end
        println(io, "\\end{tabular}")
    end
    return path
end

"""
    run_table5(; root = project_root())

Port the R simple-case model and generate replicated Table 5 outputs.
"""
function run_table5(; root::AbstractString = project_root())
    outdir = table_output_dir(root)
    mkpath(outdir)

    no_gender = solve_no_gender_case()
    diff_nu = solve_gender_diff_nu_case()
    tastes = solve_tastes_case()

    CSV.write(joinpath(outdir, "table5_panel_a_no_gender.csv"), no_gender)
    CSV.write(joinpath(outdir, "table5_panel_b_gender_diff_nu.csv"), diff_nu)
    CSV.write(joinpath(outdir, "table5_panel_c_tastes.csv"), tastes)
    write_table5_tex(joinpath(outdir, "table5_replicated.tex"), no_gender, diff_nu, tastes)

    return (; no_gender, diff_nu, tastes,
            tex = joinpath(outdir, "table5_replicated.tex"))
end
