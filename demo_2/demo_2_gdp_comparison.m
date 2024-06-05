gdp_baseline = readtable('base_gdp_results.xlsx', 'Sheet', 'China');
gdp_scenario = readtable('demo_2_gdp_results.xlsx', 'Sheet', 'China');

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Graph GDP growth rate
gdpb = gdp_baseline.Growth_rate(4:56);
gdps = gdp_scenario.Growth_rate(26:56);
years = 1998:2050;
y_limits = [0, 0.1];
y_ticks = 0:0.02:0.1;
figure;
plot(years(1:53), gdpb, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(23:53), gdps, 'Color', colour2, 'LineStyle', '-.', 'LineWidth', 2);
ylim(y_limits);
yticks(y_ticks);
title('Real GDP Growth Rate of China', 'FontName', 'SansSerif');
legend('Baseline', 'Declining employment', 'Location', 'northeast', 'FontName', 'SansSerif');
xlabel('Year', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');