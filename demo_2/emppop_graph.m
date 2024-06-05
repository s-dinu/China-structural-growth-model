input = readtable('demo_2_input.xlsx');
projections = readtable('demo_2_projections.xlsx');
projections_us = readtable('demo_2_projections_us.xlsx');

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Graph GDP growth rate
repeated_proj = repelem(projections.emppop_projections(25), 42);
repeated_proj_us = repelem(projections_us.emppop_projections_us(25), 42);
hist = projections.emppop_projections(1:25);
hist_us = projections_us.emppop_projections_us(1:25);
proj = projections.emppop_projections(25:66);
proj_us = projections_us.emppop_projections_us(25:66);
years = 1995:2060;
y_limits = [0.4, 0.6];
y_ticks = 0.4:0.05:0.6;
figure;
plot(years(1:25), hist, 'Color', colour1, 'LineStyle', '-', 'LineWidth', 2);
hold on;
plot(years(25:66), repeated_proj, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2, 'DisplayName', 'CN baseline');
hold on;
plot(years(25:66), proj, 'Color', colour1, 'LineStyle', ':', 'LineWidth', 2, 'DisplayName', 'CN projections');
hold on;
plot(years(1:25), hist_us, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
hold on;
plot(years(25:66), repeated_proj_us, 'Color', colour2, 'LineStyle', '-.', 'LineWidth', 2, 'DisplayName', 'US baseline');
hold on;
plot(years(25:66), proj_us, 'Color', colour2, 'LineStyle', ':', 'LineWidth', 2, 'DisplayName', 'US projections');
ylim(y_limits);
yticks(y_ticks);
title('Employment-to-population ratio', 'FontName', 'SansSerif');
legend('CN', '', '', 'US', '', '', 'Location', 'southwest', 'FontName', 'SansSerif');
source_text_1 = 'Note: The dash-dotted lines show the baseline assumptions. The dotted lines show the OECD projections for potential employment-to-population ratio in the period 2020-2060.';
source_text_2 = 'Source: PWT 10.01, OECD Economic Outlook no. 114, authors’ own calculation';
annotation('textbox', [0.085, 0.01, 0.8, 0.1], 'String', source_text_1, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif');
annotation('textbox', [0.085, 0.01, 0.8, 0.11], 'String', source_text_2, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif', 'Position', [0.085, 0.0475, 0.8, 0.1]);
set(gca, 'FontName', 'SansSerif','Position', [0.1, 0.2, 0.8, 0.7]);