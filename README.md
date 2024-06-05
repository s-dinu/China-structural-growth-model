# China's structural growth model

### Table of Contents
- [Main folders](#main-folders)
- [Files](#files)
- [Model estimation](#model-estimation)

### Main folders
All the folders in this project should be downloaded and moved to the Dynare 5.4 folder on your device to enable the model estimation. One main folder was created for each model (sub)scenario:
*	**base** – Baseline scenario
*	**demo_1** – Lower fertility subscenario
*	**demo_2** – Lower labour force participation subscenario
*	**prod_1** – TFP growth slowdown subscenario
*	**prod_21** – FDI outflows 21-23 subscenario
*	**prod_22** – FDI outflows 21-26 subscenario

### Files
The files in each folder are codes specific to the scenario analysis (their name starts with the abbreviation of the scenario name, which will be generically denoted as **x**), codes used to create graphs, or files with exogenous data, as listed below:
*	*x_calibration.R* – used for parameter calibration and writing the Dynare code for model estimation for both China and the US (*_us* is added to the *.mod* file name to differentiate the US from China)
*	*x_results.m* – used to create the (sub)scenarios graphs for relative income per capita of China (% of US), income per capita growth rate in China, relative TFP of China (% of US), investment in China (% of GDP), and return to capital in China (%); also, used to get the original values of GDP for China in the first sheet of the Excel file *x_gdp_results.xlsx*
*	*x_results_us.m* – used to get the original values of GDP for the US in the second sheet of the Excel file *x_gdp_results.xlsx*
*	*x_gdp_comparison.m* (only in the alternative subscenarios folders) – used after running both *x_results.m* and *x_results_us.m* to create a graph that compares China’s GDP projections in the alternative subscenario with the baseline
*	*demo_1_create_table.m* (only in **demo_1**) – used to create a table for each of the three fertility scenarios after the Dynare estimation for China in order to store the results needed for the graphs
*	*emppop_graph.m* (only in **demo_2**) – used after running *demo_2_calibration.R* for creating ‘Figure 8: Evolution of potential employment in China’
*	*fdi_ceic.m* (only in **prod_21**) – used for creating ‘Figure 13: Evolution of FDI inflows in China, 2020-2023’
*	*Chen_data.xlsx* – contains the data from W. Chen et al. (2019) in the ‘Final data’ sheet, which is needed for the investment and capital return graphs
*	*pop_growth.csv* – contains the UN World Population Prospects 2022 medium-fertility demographic projections for China and the US until 2100
*	*pwt1001.xlsx* – contains the data from the Penn World Table version 10.01
*	*base_gdp_results.xlsx* (only in the alternative subscenarios folders) – contains the original GDP values from the baseline scenario (pre-saved file from the base folder, but can be updated following a re-estimation of the baseline)
*	*unpop.csv* (only in **demo_1**) – contains the data for demographic projections for China and the US based on the three UN World Population Prospects 2022 fertility scenarios
*	*fertility.xlsx* (only in **demo_1**) – contains the population projections for China based on the three UN World Population Prospects 2022 fertility scenarios, which are needed to obtain the original GDP values for China
*	*oecd_projections.xlsx* (only in **demo_2**) – contains the employment and population projections for China published in the OECD Long-Term Baseline – December 2023
*	*base_tfp* (only in **prod_1**, **prod_21**, and **prod_22**) – contains the TFP values from the baseline scenario (pre-saved file from the base folder, but can be updated following a re-estimation of the baseline)
*	*CBO_CPI_projections.pdf* and *FDI_projections.xlsx* (only in **prod_21**) – contain the assumptions used for the re-calculation of TFP projections for the FDI outflows subscenarios

There is an additional folder **motivation** which includes other codes and files used to create several graphs/tables in the paper:
*	*ea.m* (based on *east_asia.xlsx*) – ‘Figure 3: Conditional convergence in East Asian countries’
*	*gdp_growth.m* (based on *gdp_history.xlsx*) – ‘Figure 1: China’s economic development in a domestic context’ and ‘Figure 2: China’s economic development in an international context’
*	*fert_compare.m* (based on *fert_rate.xlsx*) – ‘Figure 6: Fertility scenarios for China’
*	*histtfp.m* (based on *hist_TFP.xlsx*) – ‘Figure 10: Productivity evolution in China’
*	*conclusion_table.xlsx* – ‘Table 9: Downside risks to China’s growth rate (deviations from baseline)’
*	*appendix_table.xlsx* – ‘Appendix - China’s structural growth rate projections, 2025-2100’

### Model estimation
Based on these files, the model estimation is performed in this way, with the exception of **demo_1**:
1.	Run *x_calibration.R*
2.	Run the newly created file *x.mod* and *x_results.m* in MATLAB.
3.	Clear the MATLAB workspace
4.	Run the newly created file *x_us.mod* and *x_results_us.m* in MATLAB.

For **demo_1**:
1.	Change the letter to ‘l’ (corresponding to the low fertility scenario) in Line 146 in *x_calibration.R*
2.	Run *x_calibration.R*
3.	Run the newly created file *x.mod* and *demo_1_create_table.m* in MATLAB.
4.	Clear the MATLAB workspace
5.	Repeat steps 1-4 by changing the letter to ‘m’ and ‘h’ subsequently in Line 146 in *x_calibration.R*
6.	Run *x_results.m* in MATLAB.
7.	Clear the MATLAB workspace
8.	Run the newly created file *x_us.mod* and *x_results_us.m* in MATLAB.
