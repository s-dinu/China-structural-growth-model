# Housekeeping
rm(list = ls())
cat("\014")

# Libraries
library(readxl)
library(dplyr)
library(openxlsx)

# Read PWT data
pwt_file <- "pwt1001.xlsx"
data <- read_excel(pwt_file, sheet=3)

# Additional variables
data <- data %>%
  arrange(countrycode, year) %>%
  group_by(countrycode) %>%
  mutate(change_rgdpo = (rgdpo-lag(rgdpo))/lag(rgdpo), # US growth rate
         capsh = 1-labsh, # Capital share
         gcf_nx = csh_i+csh_x+csh_m, # Alternative investment rate
         emp_pop = emp/pop, # Employment-to-population ratio
         rgdpopercap = rgdpo/emp, # Output per capita
         incpercap = rgdpo/pop, # Income per capita
         cgdpopercap = cgdpo/emp, # Nominal output per capita
         nomincpercap = cgdpo/pop, # Nominal income per capita
         log_incpercap = log(incpercap)) # Logarithm of income per capita

# Filter data for 1995-2019
usa_data_1995 <- data %>%
filter(countrycode=="USA" & year>=1995 & year<=2019)
chn_data_1995 <- data %>%
filter(countrycode=="CHN" & year>=1995 & year<=2019)
usa_chn_data_1995 <- merge(chn_data_1995, usa_data_1995, by = "year", suffixes = c("_china", "_usa"))

# Relative variables
usa_chn_data_1995 <- usa_chn_data_1995 %>%
  mutate(relative_tfp = usa_chn_data_1995$cwtfp_china[usa_chn_data_1995$year == 2017] * rwtfpna_china / rwtfpna_usa, # Relative TFP of China
         y = incpercap_china/incpercap_usa, # Relative income per capita of China
         g_y = 0.02+(nomincpercap_china - lag(nomincpercap_china))/lag(nomincpercap_china)) # Change in relative income per capita of China

# Parameters
g_1995 <- mean(usa_data_1995$change_rgdpo, na.rm = TRUE)
g <- 0.02
irr_1995 <- mean(usa_data_1995$irr, na.rm = TRUE)
beta_1995 <- round((1+g)/(1+irr_1995), digits = 3)
theta_1995 <- round(mean(chn_data_1995$capsh, na.rm = TRUE), digits = 2)
theta_star_1995 <- round(mean(usa_data_1995$capsh, na.rm = TRUE), digits = 2)
delta_1995 <- round(mean(chn_data_1995$delta, na.rm = TRUE), digits = 3)
delta_star_1995 <- round(mean(usa_data_1995$delta, na.rm = TRUE), digits = 3)

# System of equations for gamma0 and k0
gamma_0 <- function(g, beta, theta, l_0, delta, k_star_0, l_star_0, theta_star, rho) {
f <- function(x) c(1+g-beta*(theta*x[2]^(theta-1)*(x[1]*l_0)^(1-theta)+1-delta),
                   (x[2]^theta*l_0^(1-theta)*x[1]^(1-theta))/(k_star_0^theta_star*l_star_0^(1 - theta_star))-rho)
result <- optim(c(0.03, 0.27), function(x) sum(f(x)^2), method = "CG")
R <- result$par
return(R)
}
theta <- 0.5
l_0 <- chn_data_1995$emp_pop[chn_data_1995$year == 1995]
l_star_0 <- usa_data_1995$emp_pop[usa_data_1995$year == 1995]
kstar0 <- function(x, l_star_0, theta_star_1995, g, beta_1995, delta_star_1995) {
  return((1 + g) - beta_1995 * (theta_star_1995 * x^(theta_star_1995 - 1) * l_star_0^(1 - theta_star_1995) + 1 - delta_star_1995))
}
optkstar0 <- optim(c(3.59), function(x) sum(kstar0(x, l_star_0, theta_star_1995, g, beta_1995, delta_star_1995)^2), method = "CG")
k_star_0 <- optkstar0$par
rho <- chn_data_1995$rgdpopercap[chn_data_1995$year == 1995]/usa_data_1995$rgdpopercap[usa_data_1995$year == 1995]
R <- gamma_0(g, beta_1995, theta, l_0, delta_1995, k_star_0, l_star_0, theta_star_1995, rho)
gamma0 <- round(R[1], digits = 2)
k0 <- round(R[2], digits = 2)

# Addition of TFP projections for 2020-2040
tfp_projections <- data.frame(
  year = 1995:2019,
  CTFP_CN_2017 = rep(usa_chn_data_1995$cwtfp_china[usa_chn_data_1995$year == 2017], times = 25),
  RTFP_CN = usa_chn_data_1995$rwtfpna_china,
  RTFP_US = usa_chn_data_1995$rwtfpna_usa
)
tfp_projections <- tfp_projections %>%
  mutate(g_RTFP_US = RTFP_US/lag(RTFP_US)-1) 
TFP_growth_US <- mean(tfp_projections$g_RTFP_US, na.rm = TRUE)
TFP_growth_CN <- 0.017
for (new_year in 2020:2020) {
  tfp_projections <- rbind(tfp_projections, c(new_year, 
                                              tfp_projections$CTFP_CN_2017[nrow(tfp_projections)], 
                                              tfp_projections$RTFP_CN[nrow(tfp_projections)] * (1 + TFP_growth_CN),
                                              tfp_projections$RTFP_US[nrow(tfp_projections)] * (1 + TFP_growth_US),
                                              TFP_growth_US))
}
TFP_growth_CN <- 0.016
for (new_year in 2021:2023) {
  tfp_projections <- rbind(tfp_projections, c(new_year, 
                                              tfp_projections$CTFP_CN_2017[nrow(tfp_projections)], 
                                              tfp_projections$RTFP_CN[nrow(tfp_projections)] * (1 + TFP_growth_CN),
                                              tfp_projections$RTFP_US[nrow(tfp_projections)] * (1 + TFP_growth_US),
                                              TFP_growth_US))
}
TFP_growth_CN <- 0.012
for (new_year in 2024:2025) {
  tfp_projections <- rbind(tfp_projections, c(new_year, 
                                              tfp_projections$CTFP_CN_2017[nrow(tfp_projections)], 
                                              tfp_projections$RTFP_CN[nrow(tfp_projections)] * (1 + TFP_growth_CN),
                                              tfp_projections$RTFP_US[nrow(tfp_projections)] * (1 + TFP_growth_US),
                                              TFP_growth_US))
}
TFP_growth_CN <- 0.010
for (new_year in 2026:2030) {
  tfp_projections <- rbind(tfp_projections, c(new_year, 
                                              tfp_projections$CTFP_CN_2017[nrow(tfp_projections)], 
                                              tfp_projections$RTFP_CN[nrow(tfp_projections)] * (1 + TFP_growth_CN),
                                              tfp_projections$RTFP_US[nrow(tfp_projections)] * (1 + TFP_growth_US),
                                              TFP_growth_US))
}
TFP_growth_CN <- 0.006
TFP_growth_US <- mean(tfp_projections$g_RTFP_US, na.rm = TRUE)
for (new_year in 2031:2035) {
  tfp_projections <- rbind(tfp_projections, c(new_year, 
                                              tfp_projections$CTFP_CN_2017[nrow(tfp_projections)], 
                                              tfp_projections$RTFP_CN[nrow(tfp_projections)] * (1 + TFP_growth_CN),
                                              tfp_projections$RTFP_US[nrow(tfp_projections)] * (1 + TFP_growth_US),
                                              TFP_growth_US))
}
TFP_growth_CN <- 0.005
TFP_growth_US <- mean(tfp_projections$g_RTFP_US, na.rm = TRUE)
for (new_year in 2036:2040) {
  tfp_projections <- rbind(tfp_projections, c(new_year, 
                                              tfp_projections$CTFP_CN_2017[nrow(tfp_projections)], 
                                              tfp_projections$RTFP_CN[nrow(tfp_projections)] * (1 + TFP_growth_CN),
                                              tfp_projections$RTFP_US[nrow(tfp_projections)] * (1 + TFP_growth_US),
                                              TFP_growth_US))
}
tfp_projections <- tfp_projections %>%
  mutate(relative_tfp = CTFP_CN_2017 * RTFP_CN / RTFP_US)

# Least squares optimisation - TFP
objective_function <- function(params, data) {
  eta <- params[1]
  gamma <- params[2]
  alpha <- numeric(106)
  model_tfp <- numeric(length(data$year))
  model_tfp[1] <- gamma0^(1 - theta)
  for (t in 2:106) {
    if (t == 2) {
      alpha[t] <- exp((1 - eta) * log(gamma0))/gamma
    } else {
      alpha[t] <- exp((1 - eta) * log(alpha[t - 1]))
    }}
  for (t in 2:46) {
    model_tfp[t] <- (gamma * alpha[t])^(1 - theta)
  }
  sum_squared_diff <- sum((data$relative_tfp[1:46] - model_tfp[1:46])^2)
  return(sum_squared_diff)
}
initial_params <- c(0.08, 0.22)
result <- optim(par = initial_params, fn = objective_function, data = tfp_projections, method = "CG")
optimal_eta <- round(result$par[1], digits = 2)
optimal_gamma <- round(result$par[2], digits = 2)

# Calibration results
parameter_table <- data.frame(
  Parameter = c("Discount factor", "Capital share, China", "Capital share, US", "Depreciation rate, China", "Depreciation rate, US", "Technology growth rate, US", "Initial technology, China", "Catch-up bound", "Catch-up rate"),
  Value = c(beta_1995, theta, theta_star_1995, delta_1995, delta_star_1995, g, gamma0, optimal_gamma, optimal_eta)
)

# Input tables
input_path <- "prod_22_input.xlsx"
write.xlsx(usa_chn_data_1995, input_path, sheetName = "Sheet1", rowNames = FALSE)
input_path_2 <- "prod_22_input_2.xlsx"
write.xlsx(tfp_projections, input_path_2, sheetName = "Sheet1", rowNames = FALSE)

# Exogenous variables
years <- 1995:2100
emp_pop_values <- ifelse(years <= 2019, chn_data_1995$emp_pop[match(years, chn_data_1995$year)], chn_data_1995$emp_pop[chn_data_1995$year == 2019])
emp_pop_values_us <- ifelse(years <= 2019, usa_data_1995$emp_pop[match(years, usa_data_1995$year)], usa_data_1995$emp_pop[usa_data_1995$year == 2019])
pop_growth_data <- read.csv("pop_growth.csv")
china_pop_growth_data <- pop_growth_data[pop_growth_data$Location == "China", ]
usa_pop_growth_data <- pop_growth_data[pop_growth_data$Location == "United States of America", ]
pop_growth_values <- china_pop_growth_data$Value
pop_growth_values_us <- usa_pop_growth_data$Value
alpha_values <- numeric(length(years))
alpha_values[1] <- gamma0/optimal_gamma
alpha_values[2] <- exp((1 - optimal_eta) * log(gamma0))/optimal_gamma
for (t in 3:length(alpha_values)){
  alpha_values[t] <- exp((1 - optimal_eta) * log(alpha_values[t - 1]))}
model_tfp <- numeric(46)
model_tfp[1] <- gamma0^(1 - theta)
for (t in 2:46) {
  model_tfp[t] <- (optimal_gamma * alpha_values[t])^(1 - theta)
}
# sum_squared_diff <- sum((usa_chn_data_1995$relative_tfp[1:25] - model_tfp[1:25])^2)
exo_var <- data.frame(
  year = years,
  l = round(emp_pop_values, digits = 4),
  n = round(pop_growth_values, digits = 4),
  alpha = round(alpha_values, digits = 4)
)
l_as_string <- paste(exo_var$l, collapse = ", ")
n_as_string <- paste(exo_var$n, collapse = ", ")
alpha_as_string <- paste(exo_var$alpha, collapse = ", ")
exo_var_us <- data.frame(
  year = years,
  l = round(emp_pop_values_us, digits = 4),
  n = round(pop_growth_values_us, digits = 4)
)
l_as_string_us <- paste(exo_var_us$l, collapse = ", ")
n_as_string_us <- paste(exo_var_us$n, collapse = ", ")

# Dynare file for model estimation - China

model <- paste("//Number of periods
@#define simulation_periods=106

//Define variables
var c       ${c}$         (long_name='Consumption')
    k       ${k}$         (long_name='Capital')
    y       ${y}$         (long_name='Output')
    i       ${i}$         (long_name='Investment')
    g_y     ${\\delta y}$ (long_name='Growth rate of output')
    r_k     ${r_k}$       (long_name='Return to capital')
    i_y     ${i_y}$       (long_name='Investment rate')
    tfp     ${tfp}$       (long_name='Total factor productivity')
;

//Define exogenous variables
varexo  
l     ${l}$     (long_name='Employment-to-population ratio')
n     ${n}$     (long_name='Population growth')
alpha ${alpha}$ (long_name='Distance to the technology frontier')
;

//Define parameters
parameters 
beta            ${\\beta}$        (long_name='Discount factor')
theta           ${\\theta}$       (long_name='Capital share - China')
theta_star      ${\\theta_star}$  (long_name='Capital share - US')
delta           ${\\delta}$       (long_name='Depreciation rate - China')
delta_star      ${\\delta_star}$  (long_name='Depreciation rate - US')
g               ${\\g}$           (long_name='Technology growth rate - US') 
gamma0          ${\\gamma0}$      (long_name='Initial technology - China')
gamma           ${\\gamma}$       (long_name='Catch-up bound')
eta             ${\\eta}$         (long_name='Catch-up rate')
;

//Set parameters
beta = ", round(beta_1995, digits = 3),";\n", 
               "theta = ", round(theta, digits = 2),";\n", 
               "theta_star = ", round(theta_star_1995, digits = 2),";\n",
               "delta = ", round(delta_1995, digits = 3),";\n",
               "delta_star = ", round(delta_star_1995, digits = 3),";\n",
               "g = ", round(g, digits = 2),";\n",
               "gamma0 = ", round(gamma0, digits = 2),";\n",
               "gamma = ", round(optimal_gamma, digits = 2),";\n",
               "eta = ", round(optimal_eta, digits = 2),";\n",
               "
//Enter the model equations
model;
    [name='Investment equation']
    i(-1)=(1+g)*(1+n/100)*k-(1-delta)*k(-1);
    [name='Resource constraint']
    c+i=y;
    [name='Euler equation']
    1/c*(1+g)=beta*1/c(+1)*(theta*y(+1)/k(+1)+1-delta);
    [name='Production function']
    y=k^theta*(gamma*alpha*l)^(1-theta);
    [name='Definition output growth rate']
    g_y=(y-y(-1))/y(-1)+g;
    [name='Definition return to capital']
    r_k=i/k;
    [name='Definition investment rate']
    i_y=i/y;
    [name='Definition total factor productivity']
    tfp=(gamma*alpha)^(1-theta);
end;

//Initial values
initval;
    l=", exo_var$l[1], "; \n",
               "    n=", exo_var$n[1], "; \n",
               "    alpha=", exo_var$alpha[1], "; \n",
               "    k=(((1+g)*beta^(-1)+delta-1)*(theta)^(-1))^(1/(theta-1))*gamma0*l;
    i=(1+g)*(1+n/100)*k-(1-delta)*k;
    y=k^theta*(gamma0*l)^(1-theta);
    c=y-i;
end;
check;

//Shocks (path of exogenous variables)
shocks;
    var l;
    periods 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106;
    values ", l_as_string, "; \n",
               "    var n;
    periods 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106;
    values ", n_as_string, "; \n",
               "    var alpha;
    periods 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106;
    values ", alpha_as_string, "; \n",
               "end;

//Final values
endval;
    l=", exo_var$l[106], "; \n",
               "    n=", exo_var$n[106], "; \n",
               "    alpha=", exo_var$alpha[106], "; \n",
               "    k=(((1+g)*beta^(-1)+delta-1)*(theta^(-1)))^(1/(theta-1))*gamma*l;
    i=(1+g)*(1+n/100)*k-(1-delta)*k;
    y=k^theta*(gamma*l)^(1-theta);
    c=y-i;
end;

//Perfect foresight setup: simulation for 106 periods (can check the settings in oo_.endo_simul and oo_.exo_simul)
perfect_foresight_setup(periods=@{simulation_periods});

//Compute the solution
perfect_foresight_solver;

//Graphs
rplot k c i y;
rplot g_y;
rplot i_y;
rplot r_k;
rplot tfp;", sep = "")
mod_file_path <- "prod_22.mod"
writeLines(model, mod_file_path)

# Dynare file for model estimation - US

model_us <- paste("//Number of periods
@#define simulation_periods=106

//Define variables
var c_star       ${c_star}$         (long_name='Consumption')
    k_star       ${k_star}$         (long_name='Capital')
    y_star       ${y_star}$         (long_name='Output')
    i_star       ${i_star}$         (long_name='Investment')
    g_y_star     ${\\delta y_star}$ (long_name='Growth rate of output')
    r_k_star     ${r_k_star}$       (long_name='Return to capital')
    i_y_star     ${i_y_star}$       (long_name='Investment rate')
;

//Define exogenous variables
varexo  
l_star     ${l_star}$     (long_name='Employment-to-population ratio')
n_star     ${n_star}$     (long_name='Population growth')
;

//Define parameters
parameters 
beta            ${\\beta}$        (long_name='Discount factor')
theta           ${\\theta}$       (long_name='Capital share - China')
theta_star      ${\\theta_star}$  (long_name='Capital share - US')
delta           ${\\delta}$       (long_name='Depreciation rate - China')
delta_star      ${\\delta_star}$  (long_name='Depreciation rate - US')
g               ${\\g}$           (long_name='Technology growth rate - US') 
;

//Set parameters
beta = ", round(beta_1995, digits = 3),";\n", 
               "theta = ", round(theta, digits = 2),";\n", 
               "theta_star = ", round(theta_star_1995, digits = 2),";\n",
               "delta = ", round(delta_1995, digits = 3),";\n",
               "delta_star = ", round(delta_star_1995, digits = 3),";\n",
               "g = ", round(g, digits = 2),";\n",
               "
//Enter the model equations
model;
    [name='Investment equation']
    i_star(-1)=(1+g)*(1+n_star/100)*k_star-(1-delta_star)*k_star(-1);
    [name='Resource constraint']
    c_star+i_star=y_star;
    [name='Euler equation']
    1/c_star*(1+g)=beta*1/c_star(+1)*(theta_star*y_star(+1)/k_star(+1)+1-delta_star);
    [name='Production function']
    y_star=k_star^theta_star*l_star^(1-theta_star);
    [name='Definition output growth rate']
    g_y_star=(y_star-y_star(-1))/y_star(-1)+g;
    [name='Definition return to capital']
    r_k_star=i_star/k_star;
    [name='Definition investment rate']
    i_y_star=i_star/y_star;
end;

//Initial values
initval;
    l_star=", exo_var_us$l[1], "; \n",
               "    n_star=", exo_var_us$n[1], "; \n",
               "    k_star=(((1+g)*beta^(-1)+delta_star-1)*(theta_star)^(-1))^(1/(theta_star-1))*l_star;
    i_star=(1+g)*(1+n_star/100)*k_star-(1-delta_star)*k_star;
    y_star=k_star^theta_star*l_star^(1-theta_star);
    c_star=y_star-i_star;
end;
check;

//Shocks (path of exogenous variables)
shocks;
    var l_star;
    periods 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106;
    values ", l_as_string_us, "; \n",
               "    var n_star;
    periods 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106;
    values ", n_as_string_us, "; \n",
               "end;

//Final values
endval;
    l_star=", exo_var_us$l[106], "; \n",
               "    n_star=", exo_var_us$n[106], "; \n",
               "    k_star=(((1+g)*beta^(-1)+delta-1)*(theta_star^(-1)))^(1/(theta_star-1))*l_star;
    i_star=(1+g)*(1+n_star/100)*k_star-(1-delta_star)*k_star;
    y_star=k_star^theta_star*l_star^(1-theta_star);
    c_star=y_star-i_star;
end;

//Perfect foresight setup: simulation for 106 periods (can check the settings in oo_.endo_simul and oo_.exo_simul)
perfect_foresight_setup(periods=@{simulation_periods});

//Compute the solution
perfect_foresight_solver;

//Graphs
rplot k_star c_star i_star y_star;
rplot g_y_star;
rplot i_y_star;
rplot r_k_star;", sep = "")
mod_file_path <- "prod_22_us.mod"
writeLines(model_us, mod_file_path)