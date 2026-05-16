using CubasJuhnSilos

result = CubasJuhnSilos.run_table5()
@assert size(result.no_gender, 1) == 5
@assert size(result.diff_nu, 1) == 8
@assert size(result.tastes, 1) == 8
