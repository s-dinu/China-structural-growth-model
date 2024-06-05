data = readtable('east_asia.xlsx', 'Sheet', 'Comparison_EA');
year = data.Year;
chn = data.CHN;
jpn = data.JPN;
kor = data.KOR;
twn = data.TWN;

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Plot RGDPO/C for East Asia countries
y_limits = [3.4, 5];
y_ticks = 3.4:0.4:5;
figure;
plot(year(1:25), chn(1:25), 'Color', colour1, 'LineWidth', 2, 'LineStyle', '-');
hold on;
plot(year(1:25), jpn(1:25), 'Color', colour2, 'LineWidth', 2, 'LineStyle', '-');
hold on;
plot(year(1:25), kor(1:25), 'Color', colour3, 'LineWidth', 2, 'LineStyle', '-');
hold on;
plot(year(1:25), twn(1:25), 'Color', colour4, 'LineWidth', 2, 'LineStyle', '-');
hold on;
plot(year(25:end), chn(25:end), 'Color', colour1, 'LineWidth', 2, 'LineStyle', ':');
hold on;
plot(year(25:end), jpn(25:end), 'Color', colour2, 'LineWidth', 2, 'LineStyle', ':');
hold on;
plot(year(25:end), kor(25:end), 'Color', colour3, 'LineWidth', 2, 'LineStyle', ':');
hold on;
plot(year(25:end), twn(25:end), 'Color', colour4, 'LineWidth', 2, 'LineStyle', ':');
ylim(y_limits);
yticks(y_ticks);
title('Evolution of income per capita (in log terms)', 'FontName', 'SansSerif');
legend('CN', 'JP', 'KR', 'TW', 'Location', 'southeast', 'FontName', 'SansSerif');
source_text_1 = 'Note: The solid lines for Japan, Korea, and Taiwan show their per capita growth from the year they achieved China’s 1995 level up to the equivalent 2019 level. The dotted lines show the growth of the same countries 25 years in the future.';
source_text_2 = 'Source: PWT 10.01, authors’ own calculation';
annotation('textbox', [0.085, 0.01, 0.8, 0.1], 'String', source_text_1, 'FontSize', 9, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif');
annotation('textbox', [0.085, 0.01, 0.8, 0.11], 'String', source_text_2, 'FontSize', 9, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif', 'Position', [0.085, 0.0475, 0.8, 0.1]);
set(gca, 'FontName', 'SansSerif','Position', [0.1, 0.2, 0.8, 0.7]);