fert_rate = readtable('fert_rate.xlsx');

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Graph GDP growth rate
fh = fert_rate.High_fertility(27:106);
fm_h = fert_rate.Median(1:27);
fm_f = fert_rate.Median(27:106);
fl = fert_rate.Low_fertility(27:106);
years = 1995:2100;
y_limits = [0, 3];
y_ticks = 0:1:3;
figure;
plot(years(27:106), fh, 'Color', colour1, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(1:27), fm_h, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
hold on;
plot(years(27:106), fm_f, 'Color', colour2, 'LineStyle', '-.', 'LineWidth', 2);
hold on;
plot(years(27:106), fl, 'Color', colour3, 'LineStyle', '-.', 'LineWidth', 2);
ylim(y_limits);
yticks(y_ticks);
title('Fertility rate projections in China', 'FontName', 'SansSerif');
legend('High fertility', 'Historical data', 'Medium fertility', 'Low fertility', 'Location', 'southeast', 'FontName', 'SansSerif');
source_text = 'Source: United Nations - World Population Prospects 2022';
annotation('textbox', [0.115, 0, 0.8, 0.05], 'String', source_text, 'FontSize', 8, 'HorizontalAlignment', 'left', 'LineStyle', 'none', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');