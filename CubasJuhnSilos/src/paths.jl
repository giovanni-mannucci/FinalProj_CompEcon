function project_root()
    return normpath(joinpath(@__DIR__, "..", ".."))
end

replication_root(root::AbstractString = project_root()) =
    joinpath(root, "replication-package", "Codes_CubasJuhnSilos")

simple_case_root(root::AbstractString = project_root()) =
    joinpath(replication_root(root), "EJ_replicate_model", "Sect_4_Simple_Case_code")

table_output_dir(root::AbstractString = project_root()) =
    joinpath(root, "output", "tables")

figure_output_dir(root::AbstractString = project_root()) =
    joinpath(root, "output", "figures")
