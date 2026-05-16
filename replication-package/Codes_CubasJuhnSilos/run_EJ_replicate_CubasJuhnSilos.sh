#!/bin/bash
# FIRST GET ALL RAW DATA READY
rm -rf ./Stata_Raw_Data
mkdir ./Stata_Raw_Data
cd ./Raw_Data/Get_Atus_Raw_Data/

stata -b ./atusact_raw_0314.do
stata -b ./atusresp_raw_0314.do
stata -b ./atusrost_raw_0314.do
stata -b ./atuscps_raw_0314.do
stata -b ./atus_weights.do
stata -b ./get_weights.do
echo "Done getting raw ATUS data"
cd ../Get_ACS_Raw_Data
stata -b ./get_acs.do
echo "Done getting ACS data"
cd ../occ_labels
stata -b ./import_occs_to_stata.do  
cd "../ONET/additional Onet characteristics"
stata -b ./do_additional_onet.do
cd ../8_onet_characteristics
stata -b ./do_10.do
cd ../nonroutine_and_routine_onet
stata -b ./dofile_rout.do
cd ../Basic_5
stata -b ./basic_five_merge.do
cd ../../../
echo "Done Getting ONET data"
cd ./EJ_replicate_atus
echo "Getting activity by time bins by individual - this takes hours"
stata -b 1_matrix.do
stata -b 3_matrix.do
stata -b 5_matrix.do
stata -b 6_matrix.do
rm ./id1*
rm ./id2*
rm ./id3*
rm ./id4*
rm ./id5*
rm ./id*
cd ..
cd ./EJ_replicate/document_data_new/document_dta/
stata -b do ./2_1_atus_extracts_raw_0314.do
stata -b do ./2_2_atus_data_1_merge.do
stata -b do ./2_3_atus_data_1_occs.do
stata -b do ./2_4_data_2.do
cd ./3_br_cr
stata -b do ./3a_br94.do
stata -b do ./3b_br563.do
stata -b do ./3c_cr94.do
stata -b do ./3d_cr563.do
stata -b do ./3i_br22.do
stata -b do ./3j_cr22.do
cd ..
stata -b do ./4_spouse.do
stata -b do ./5_data_5.do
cd "./6_regression data/"
stata -b do ./6_a.do
cd ..

cd "./6_regression data/6.2_ratios/"
stata -b do ./ratios_94_563_22.do
cd ../../
cd "./6_regression data/6.4_avgeduc/"
stata -b do ./6.4_avg_educ.do
cd ../../
cd "./6_regression data/6.5_male_overwork/"
stata -b do ./6.5_male_overwork.do
cd ../
stata -b do ./6_b_reg.do

cd ../../../table1-2
stata -b do ./3.tab1-2.do
cd ../document_data_new/hcare_detail
stata -b do ./f1.do
stata -b do ./f2.do
stata -b do ./f3_a.do
stata -b do ./f3_b.do
stata -b do ./f3_c.do
stata -b do ./f4.do
stata -b do ./f5_matrix.do
stata -b do ./f6_hcaredetail_matrix_0316.do

cd ../../table3
stata -b do ./4.tab3_hhcare_detail_reg2.do
cd ../table6-7
stata -b do ./regs_ONET_563.do
stata -b do ./6.tab6.do
stata -b do ./7.tab7.do
cd ../table4
stata -b do ./generalizing_soc.do
stata -b do ./main_code_to_2002.do
stata -b do ./5.tab4.do
cd ../fig1-4
#### FIGURES
stata -b do ./1.fig1-3.do
stata -b do ./2.fig4_563.do
cd ../appendix
stata -b do ./tabA5-A6.do 
stata -b do ./tabA7.do 
stata -b do ./tabA9.do 

cd ../../
# Now run model and generate tables 5,8,9,10,11, and 12 and figures 5 and 6 (plus
# appendix stuff)
cd EJ_replicate_model
rm ./latex_tables/table*
rm ./latex_tables/*.Rout
rm ./latex_tables/*.pdf
rm ./latex_tables/*.log
rm ./latex_tables/*.aux
rm -rf ./Quantitative_Analysis/model_output
rm -rf ./Quantitative_Analysis/data
rm -rf ./Quantitative_Analysis/sensitivity_cobb_douglas
##### run simple cases
cd ./Sect_4_Simple_Case_code
Rscript  ./simple_cases.R 
cd ./two-earner-households
Rscript ./main_code_ge.R 
cd ../../
####### run data programs to get moments for the model
mkdir ./Quantitative_Analysis/data ## folder to store all files
cd ./Quantitative_Analysis/compute_emp_moments
rm ./*.Rout
stata -b do  ./get_data.do

Rscript ./compute_br_22occs.R
Rscript ./moments_byoccs_def.R
Rscript ./reg_data_22occs.R  
Rscript ./decomp_gender_gap.R

cd ../model_files/
####### folder to store model output (CES case)
mkdir -p ../model_output
#### peos = CES parameter that drives the elasticity of substitution
#### between occupations
######### occupations, experiment (see code)
R --vanilla --args peos 0.66667 experiment 0 model_output_folder '../model_output/' model_extension '' < ./main_ge.R
R --vanilla --args peos 0.66667 experiment 1 model_output_folder '../model_output/' model_extension '' < ./main_ge.R
R --vanilla --args peos 0.66667 experiment 2 model_output_folder '../model_output/' model_extension '' < ./main_ge.R
R --vanilla --args peos 0.66667 experiment 3 model_output_folder '../model_output/' model_extension '' < ./main_ge.R
R --vanilla --args peos 0.66667 experiment 4 model_output_folder '../model_output/' model_extension '' < ./main_ge.R
R --vanilla --args peos 0.66667 experiment 5 model_output_folder '../model_output/' model_extension '' < ./main_ge.R
### folder to store model output (Cobb-Douglas case)
mkdir -p ../sensitivity_cobb_douglas
#cp ./Quantitative_Analysis/model_files/ces_param ../sensitivity_cobb_douglas
R --vanilla --args peos 1e-9 experiment 0 model_output_folder '../sensitivity_cobb_douglas/' model_extension '_cobb_douglas' < ./main_ge.R
R --vanilla --args peos 1e-9 experiment 1 model_output_folder '../sensitivity_cobb_douglas/' model_extension '_cobb_douglas' < ./main_ge.R
R --vanilla --args peos 1e-9 experiment 2 model_output_folder '../sensitivity_cobb_douglas/' model_extension '_cobb_douglas' < ./main_ge.R
R --vanilla --args peos 1e-9 experiment 4 model_output_folder '../sensitivity_cobb_douglas/' model_extension '_cobb_douglas' < ./main_ge.R
R --vanilla --args peos 1e-9 experiment 5 model_output_folder '../sensitivity_cobb_douglas/' model_extension '_cobb_douglas' < ./main_ge.R

# do psid appendix penalty regression and picture
cd ../../../Penalty_Appendix
Rscript ./penalty_regression_final.R
Rscript ./graph_table.R

# now do final latex tables (also pull tables and figures from
# EJ_Replicate folder)
cd ../EJ_replicate_model/latex_tables

# generate all tables (have to fix some of the stata .tex tables as
# they can't be compiled out of the box
Rscript ./get_numbers_table_4.R 
Rscript ./fix_tables.R
Rscript ./generate_tables.R 
Rscript ./generate_figures.R 

# bring stata-generate figures to current directory in pdf format
epstopdf ../../EJ_replicate/fig1-4/fig1.eps ./fig1.pdf
epstopdf ../../EJ_replicate/fig1-4/fig2.eps ./fig2.pdf
epstopdf ../../EJ_replicate/fig1-4/fig3.eps ./fig3.pdf
epstopdf ../../EJ_replicate/fig1-4/fig4.eps ./fig4.pdf

# run latex file
pdflatex final_model_tables.tex
cd ../..

find ./EJ_replicate -name "*.dta" -type f -delete
find ./EJ_replicate -name "*.log" -type f -delete
find ./EJ_replicate_atus -name "*.dta" -type f -delete
find ./EJ_replicate_atus -name "*.log" -type f -delete
find ./EJ_replicate_model -name "*.dta" -type f -delete
find ./EJ_replicate_model -name "*.log" -type f -delete




#
