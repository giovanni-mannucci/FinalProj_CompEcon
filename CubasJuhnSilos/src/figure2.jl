"""
    run_figure2(; root = project_root())

Prepare the Figure 2 replication step.

The original Stata package exports `fig2_3.xls` in the old binary Excel
format. `XLSX.jl` reads modern `.xlsx` files, so the next manual step is to
open that file once in Excel/LibreOffice and save it as `fig2_3.xlsx`, or to
rebuild the underlying ATUS data in Julia. Once the `.xlsx` exists, this
function will generate the two-panel figure.
"""
function run_figure2(; root::AbstractString = project_root())
    figdir = joinpath(replication_root(root), "EJ_replicate", "fig1-4")
    xlsx_path = joinpath(figdir, "fig2_3.xlsx")
    outpath = joinpath(figure_output_dir(root), "figure2_replicated.png")

    if !isfile(xlsx_path)
        msg = """
        Figure 2 not run yet.

        Needed file:
            $xlsx_path

        The replication package has `fig2_3.xls`, an old binary Excel file.
        Open it once in Excel or LibreOffice, save as `fig2_3.xlsx` in the same
        folder, then run `CubasJuhnSilos.run_figure2()` again.
        """
        mkpath(joinpath(root, "output", "logs"))
        write(joinpath(root, "output", "logs", "figure2_next_step.txt"), msg)
        return (; status = :needs_xlsx_conversion, message = msg)
    end

    workbook = XLSX.readxlsx(xlsx_path)
    sheet = workbook["Sheet1"]
    raw = sheet[:, :]
    df = DataFrame(
        grp = Int.(raw[:, 1]),
        timebin = Int.(raw[:, 2]),
        work1 = Float64.(raw[:, 3]),
        work2 = Float64.(raw[:, 4]),
        householdcare1 = Float64.(raw[:, 5]),
        householdcare2 = Float64.(raw[:, 6]),
    )

    p1data = filter(row -> row.grp == 1, df)
    p2data = filter(row -> row.grp == 2, df)

    p1 = plot(p1data.timebin, p1data.work1, label = "Men", color = :black,
              ylabel = "Minutes", xlabel = "", title = "Married with children",
              legend = :topright)
    plot!(p1, p1data.timebin, p1data.work2, label = "Women", color = :red)
    vline!(p1, [8, 17], label = "", color = :gray, linestyle = :dash)

    p2 = plot(p2data.timebin, p2data.work1, label = "Men", color = :black,
              ylabel = "Minutes", xlabel = "Hour of day", title = "Single without children",
              legend = :topright)
    plot!(p2, p2data.timebin, p2data.work2, label = "Women", color = :red)
    vline!(p2, [8, 17], label = "", color = :gray, linestyle = :dash)

    plot(p1, p2, layout = (2, 1), size = (650, 850))
    mkpath(dirname(outpath))
    savefig(outpath)
    return (; status = :ok, path = outpath)
end
