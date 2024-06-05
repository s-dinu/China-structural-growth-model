gdp_share = readtable('gdp_history.xlsx', 'Sheet', 'World share');
gdp_share_us = readtable('gdp_history.xlsx', 'Sheet', 'World share US');
gdp_trade = readtable('gdp_history.xlsx', 'Sheet', 'Trade share');
gdp_trade_us = readtable('gdp_history.xlsx', 'Sheet', 'Trade share US');
gdp_rate = readtable('gdp_history.xlsx', 'Sheet', 'GDP');

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Graph CN and US share in world GDP
gdps = gdp_share.Share(46:79);
gdps_h = gdps(1:29);
gdps_p = gdps(29:33);
gdps_us = gdp_share_us.Share(1:33);
gdps_h_us = gdps_us(1:29);
gdps_p_us = gdps_us(29:33);
years = 1995:2028;
y_limits = [0, 24];
y_ticks = 0:6:24;
figure;
plot(years(1:29), gdps_h*100, 'Color', colour1, 'LineStyle', '-', 'LineWidth', 2);
hold on
plot(years(29:33), gdps_p*100, 'Color', colour1, 'LineStyle', ':', 'LineWidth', 2);
hold on
plot(years(1:29), gdps_h_us*100, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
hold on
plot(years(29:33), gdps_p_us*100, 'Color', colour2, 'LineStyle', ':', 'LineWidth', 2);
ylim(y_limits);
yticks(y_ticks);
title('Share of world PPP GDP (%)', 'FontName', 'SansSerif');
legend('CN', '', 'US', '', 'Location', 'southeast', 'FontName', 'SansSerif');
source_text_1 = 'Note: The dotted lines show the IMF projections of the shares within global PPP GDP for China and the US for the period 2024-2029.';
source_text_2 = 'Source: International Monetary Fund via Haver Analytics';
annotation('textbox', [0.085, 0, 0.8, 0.1], 'String', source_text_1, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif');
annotation('textbox', [0.085, 0, 0.8, 0.11], 'String', source_text_2, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif', 'Position', [0.085, 0.04, 0.8, 0.1]);
set(gca, 'FontName', 'SansSerif','Position', [0.1, 0.2, 0.8, 0.7]);

% Graph CN and US share in world trade
gdpt = gdp_trade.Share(1:29);
gdpt_us = gdp_trade_us.Share(1:29);
years = 1995:2023;
y_limits = [0, 20];
y_ticks = 0:5:20;
figure;
plot(years(1:29), gdpt*100, 'Color', colour1, 'LineStyle', '-', 'LineWidth', 2);
hold on
plot(years(1:29), gdpt_us*100, 'Color', colour2, 'LineStyle', '-', 'LineWidth', 2);
ylim(y_limits);
yticks(y_ticks);
title('Share in world trade - imports and exports (%)', 'FontName', 'SansSerif');
legend('CN', 'US', 'Location', 'southeast', 'FontName', 'SansSerif');
source_text = 'Source: OECD via Haver Analytics';
annotation('textbox', [0.115, 0, 0.8, 0.05], 'String', source_text, 'FontSize', 8, 'HorizontalAlignment', 'left', 'LineStyle', 'none', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');

% Graph GDP growth rate
gdpr = gdp_rate.Share(46:74);
gdpr_trend = gdp_rate.Trend(59:74);
years = 1995:2023;
y_limits = [0, 16];
y_ticks = 0:4:16;
figure;
plot(years(1:29), gdpr*100, 'Color', colour1, 'LineStyle', '-', 'LineWidth', 2);
hold on
plot(years(14:29), gdpr_trend*100, 'Color', colour1, 'LineStyle', ':', 'LineWidth', 2);
ylim(y_limits);
yticks(y_ticks);
title('Real GDP growth rate of China (% yoy)', 'FontName', 'SansSerif');
source_text_1 = 'Note: The dotted line shows the 2008-2023 trend for the GDP growth rate in China.';
source_text_2 = 'Source: China National Bureau of Statistics via Haver Analytics';
annotation('textbox', [0.085, 0, 0.8, 0.1], 'String', source_text_1, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif');
annotation('textbox', [0.085, 0, 0.8, 0.11], 'String', source_text_2, 'FontSize', 8, 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'LineStyle', 'none', 'FontName', 'SansSerif', 'Position', [0.085, 0.04, 0.8, 0.1]);
set(gca, 'FontName', 'SansSerif','Position', [0.1, 0.2, 0.8, 0.7]);