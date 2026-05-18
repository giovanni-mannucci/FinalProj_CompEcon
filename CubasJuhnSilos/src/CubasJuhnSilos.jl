module CubasJuhnSilos

using CSV
using DataFrames
using LinearAlgebra
using NLopt
using NLsolve
using Optim
using Plots
using StatFiles
using Statistics
using XLSX

include("paths.jl")
include("regression.jl")
include("simple_cases.jl")
include("figure2.jl")
include("empirical_tables.jl")
include("quantitative_model.jl")

export run_all, run_table5, run_figure2, run_table1_table2, run_table6,
       run_table1_table2_from_dta, run_table1_table2_from_raw,
       run_table6_from_dta, run_table6_from_raw,
       run_quantitative_baseline_and_counterfactual

"""
    run_all(; root = project_root())

Run every Julia replication component that is currently implemented.

This runs Figure 2, Tables 1 and 2, Table 6, Table 5, and the quantitative
counterfactual. The empirical tables use generated Stata checkpoint files for
the heavy raw-data construction steps, then compute the final tables in Julia.
"""
function run_all(; root::AbstractString = project_root())
    mkpath(joinpath(root, "output", "tables"))
    mkpath(joinpath(root, "output", "figures"))
    mkpath(joinpath(root, "output", "logs"))

    table5 = run_table5(root = root)
    figure2 = run_figure2(root = root)
    table1_table2 = run_table1_table2(root = root)
    table6 = run_table6(root = root)
    counterfactual_5_3_2 = run_quantitative_baseline_and_counterfactual(root = root)

    return (; table5, figure2, table1_table2, table6, counterfactual_5_3_2)
end

end
