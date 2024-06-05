tfp = readtable('hist_TFP.xlsx', 'Sheet', 'Sheet1');

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Graph real TFP
rtfp = tfp.Level(1:25);
rtfp_trend = tfp.Trend(16:25);
years = 1995:2019;
y_limits = [0.7, 1.1];
y_ticks = 0.7:0.1:1.1;
figure;
plot(years(1:25), rtfp, 'Color', colour1, 'LineStyle', '-', 'LineWidth', 2);
hold on
plot(years(16:25), rtfp_trend, 'Color', colour1, 'LineStyle', ':', 'LineWidth', 2);
ylim(y_limits);
yticks(y_ticks);
title('Real TFP level of China (2017 = 1)', 'FontName', 'SansSerif');
source_text_1 = 'Note: The dotted line shows the 2010-2019 trend for the real TFP level in China.';
source_text_2 = 'Source: PWT 10.01';
annotation('textbox', [0.085, 0, 0.8, 0.1], 'String', source_text_1, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif');
annotation('textbox', [0.085, 0, 0.8, 0.11], 'String', source_text_2, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif', 'Position', [0.085, 0.04, 0.8, 0.1]);
set(gca, 'FontName', 'SansSerif','Position', [0.1, 0.2, 0.8, 0.7]);