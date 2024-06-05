output = table(c, k, y, i, g_y, r_k, i_y, tfp, 'VariableNames', {'c', 'k', 'y', 'i', 'g_y', 'r_k', 'i_y', 'tfp'});
input = readtable('prod_22_input.xlsx');
input2 = readtable('Chen_data', 'Sheet', 'Final data');
input3 = readtable('prod_22_input_2.xlsx');
input4 = readtable('base_tfp.xlsx');

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Graph y
y_model = output.y(2:82);
y_data = input.y(1:25);
years = 1995:2075;
y_limits = [0, 60];
y_ticks = 0:15:60;
figure;
plot(years(1:81), y_model*100, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(1:25), y_data*100, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
ylim(y_limits);
yticks(y_ticks);
title('Relative income per capita of China (% of US)', 'FontName', 'SansSerif');
legend('Model', 'Data', 'Location', 'southeast', 'FontName', 'SansSerif');
source_text = 'Source: PWT 10.01, authors’ own calculation';
annotation('textbox', [0.115, 0, 0.8, 0.05], 'String', source_text, 'FontSize', 8, 'HorizontalAlignment', 'left', 'LineStyle', 'none', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');

% Graph g_y
g_y_model = output.g_y(4:83);
g_y_data = input.g_y(2:25);
g_y_limits = [0, 0.15];
g_y_ticks = 0:0.03:0.15;
figure;
plot(years(2:81), g_y_model, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(2:25), g_y_data, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
ylim(g_y_limits);
yticks(g_y_ticks);
title('Income Per Capita Growth Rate', 'FontName', 'SansSerif');
legend('Model', 'Data', 'Location', 'southeast', 'FontName', 'SansSerif');
xlabel('Year', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');

% Graph tfp
tfp_model = output.tfp(2:82);
tfp_baseline = input4.TFP_baseline(1:81);
tfp_data = input3.relative_tfp(1:25);
tfp_data_2 = input3.relative_tfp(26:46);
tfp_limits = [15, 55];
tfp_ticks = 15:10:55;
figure;
plot(years(1:81), tfp_baseline*100, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(1:81), tfp_model*100, 'Color', colour2, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(1:25), tfp_data*100, 'Color', colour3, 'LineStyle', '-', 'LineWidth', 2);
hold on;
plot(years(26:46), tfp_data_2*100, 'Color', colour4, 'LineStyle', ':', 'LineWidth', 2);
ylim(tfp_limits);
yticks(tfp_ticks);
title('Relative TFP of China (% of US)', 'FontName', 'SansSerif');
legend('Model: baseline', 'Model: FDI outflows', 'Data', 'Adjusted projections', 'Location', 'southeast', 'FontName', 'SansSerif');
source_text_1 = 'Note: The dotted line shows the 2020-2040 projections for the relative TFP level of China, based on Peschel and Liu (2022) and adjusted for FDI outflows in 2021-26.';
source_text_2 = 'Source: PWT 10.01, Peschel and Liu (2022), authors’ own calculation';
annotation('textbox', [0.085, 0, 0.8, 0.1], 'String', source_text_1, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif');
annotation('textbox', [0.085, 0, 0.8, 0.11], 'String', source_text_2, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif', 'Position', [0.085, 0.04, 0.8, 0.1]);
set(gca, 'FontName', 'SansSerif','Position', [0.1, 0.2, 0.8, 0.7]);

% Graph i_y
i_y_model = output.i_y(2:82);
i_y_data = input.csh_i_china(1:25);
i_y_chen = input2.inv_rat(1:22);
i_y_limits = [15, 55];
i_y_ticks = 15:10:55;
figure;
plot(years(1:81), i_y_model*100, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(1:25), i_y_data*100, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
hold on;
plot(years(1:22), i_y_chen*100, 'Color', colour3, 'LineStyle', ':', 'LineWidth', 2);
ylim(i_y_limits);
yticks(i_y_ticks);
title('Investment (% of GDP)', 'FontName', 'SansSerif');
legend('Model', 'Data: PWT', 'Data: corrected by Chen et al. (2019)', 'Location', 'southeast', 'FontName', 'SansSerif');
xlabel('Year', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');

% Graph r_k
r_k_model = output.r_k(2:82);
r_k_data = input.irr_china(1:25);
r_k_chen = input2.ret_cap(1:22);
r_k_limits = [0, 20];
r_k_ticks = 0:5:20;
figure;
plot(years(1:81), r_k_model*100, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(1:25), r_k_data*100, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
hold on;
plot(years(1:22), r_k_chen*100, 'Color', colour3, 'LineStyle', ':', 'LineWidth', 2);
ylim(r_k_limits);
yticks(r_k_ticks);
title('Return to capital (%)', 'FontName', 'SansSerif');
legend('Model', 'Data: PWT', 'Data: corrected by Chen et al. (2019)', 'Location', 'southeast', 'FontName', 'SansSerif');
xlabel('Year', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');

% Extract initial values of variables
pwt = readtable("pwt1001.xlsx", 'Sheet', 'Data');
pop = readtable("pop_growth.csv");
pop_chn = pop.Population(strcmp(pop.Location, 'China'), :);
y_chn = y(2:107);
g = 0.02;
gdp_chn = zeros(106, 1);
delta_gdp_chn = zeros(106, 1);
for t = 1:106
    gdp_chn(t) = y(t)*pop_chn(t)*(1 + g)^t;
end
for t = 2:106
    delta_gdp_chn(t) = gdp_chn(t)/gdp_chn(t-1)-1;
end
gdp_chn_table = table((1995:2100)', gdp_chn, delta_gdp_chn, 'VariableNames', {'Year', 'Output', 'Growth_rate'});
writetable(gdp_chn_table, 'prod_22_gdp_results.xlsx', 'Sheet', 'China');