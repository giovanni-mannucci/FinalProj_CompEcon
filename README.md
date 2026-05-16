# Cubas, Juhn, and Silos Replication

This repository contains a Julia replication project for selected exhibits from
Cubas, Juhn, and Silos, "Coordinated Work Schedules and the Gender Wage Gap".

The original replication package is stored in `replication-package/`.

## Julia Package

The Julia package is `CubasJuhnSilos/`.

To instantiate the package from the repository root:

```julia
using Pkg
Pkg.activate("CubasJuhnSilos")
Pkg.instantiate()
```

## Unit Tests

Run the tests from the repository root with:

```bash
julia --project=CubasJuhnSilos -e 'using Pkg; Pkg.test()'
```

## Replication Output

The package exposes a single entry point:

```julia
using Pkg
Pkg.activate("CubasJuhnSilos")
using CubasJuhnSilos
CubasJuhnSilos.run_all()
```

Implemented outputs are written to:

- `output/tables/`
- `output/figures/`
- `output/logs/`

Currently implemented in Julia:

- Table 5, the simple two-occupation model.
- Figure 2, using the original Stata-exported `fig2_3.xlsx` checkpoint.
- Counterfactual 5.3.2, the quantitative model experiment setting all
  occupational coordination parameters to the healthcare-support value.
- Final-regression/table code for Tables 1, 2, and 6 from Stata `.dta`
  checkpoints, ready to run once those checkpoints are produced.

Tables 1, 2, and 6 require Stata intermediate `.dta` files that are not present
in the downloaded replication package. The Julia package writes notes in
`output/logs/` describing the exact missing inputs and source scripts.

Run the `.dta` checkpoint route with:

```julia
CubasJuhnSilos.run_table1_table2(source = :dta)
CubasJuhnSilos.run_table6(source = :dta)
```

For Tables 1 and 2, place this file at the original package path:

```text
replication-package/Codes_CubasJuhnSilos/EJ_replicate/document_data_new/document_dta/5_data_#5.dta
```

For Table 6, place these files at the original package paths:

```text
replication-package/Codes_CubasJuhnSilos/EJ_replicate/document_data_new/document_dta/6_regression data/6_b_reg.dta
replication-package/Codes_CubasJuhnSilos/EJ_replicate/table6-7/ONET_563b.dta
replication-package/Codes_CubasJuhnSilos/EJ_replicate/table6-7/bratio_563all.dta
```

The raw Julia route is scaffolded separately:

```julia
CubasJuhnSilos.run_table1_table2(source = :raw)
CubasJuhnSilos.run_table6(source = :raw)
```

This route documents the Stata data-construction scripts that remain to be
ported before the raw files can reproduce the same intermediate datasets.

Run the quantitative counterfactual directly with:

```julia
CubasJuhnSilos.run_quantitative_baseline_and_counterfactual()
```

It writes:

```text
output/tables/counterfactual_5_3_2_summary.csv
output/tables/counterfactual_5_3_2_baseline_regression.csv
output/tables/counterfactual_5_3_2_counter_regression.csv
```

## Report

The report source is `report.qmd`. To render it, install Quarto from
<https://quarto.org>, then run:

```bash
quarto render report.qmd
```
