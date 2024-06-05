% Extract initial values of variables
pwt = readtable("pwt1001.xlsx", 'Sheet', 'Data');
pop = readtable("pop_growth.csv");
pop_usa = pop.Population(strcmp(pop.Location, 'United States of America'), :);
y_usa = y_star(2:107);
g = 0.02;
gdp_usa = zeros(106, 1);
delta_gdp_usa = zeros(106, 1);
for t = 1:106
    gdp_usa(t) = y_usa(t)*pop_usa(t)*(1 + g)^t;
end
for t = 2:106
    delta_gdp_usa(t) = gdp_usa(t)/gdp_usa(t-1)-1;
end
gdp_usa_table = table((1995:2100)', gdp_usa, delta_gdp_usa, 'VariableNames', {'Year', 'Output', 'Growth rate'});
writetable(gdp_usa_table, 'prod_21_gdp_results.xlsx', 'Sheet', 'US');
