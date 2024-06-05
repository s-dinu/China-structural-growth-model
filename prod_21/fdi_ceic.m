fdi_data = readtable('FDI_projections.xlsx', 'Sheet', 'CEIC inflows');
month = fdi_data.SelectThisLinkAndClickRefresh_EditDownloadToUpdateDataAndAddOrR(94:109);
value = fdi_data.CN_BoP_FA_Non_reserve_DirectInvestment_Liability(94:109);

% ECB graph colours
colour1 = [0, 56, 153] / 255;
colour2 = [255, 180, 0] / 255;
colour3 = [255, 75, 0] / 255;
colour4 = [101, 184, 0] / 255;
colour5 = [0, 177, 234] / 255;

% Graph CN and US share in world GDP
y_limits = [-40, 120];
y_ticks = -40:40:120;
yTickLevel = 0;
figure;
plot(month(1:16), value/1000, 'Color', colour1, 'LineStyle', '-', 'LineWidth', 2);
hold on;
plot([min(month), max(month)], [yTickLevel, yTickLevel], 'Color', colour1, 'LineStyle', '--', 'LineWidth', 1);
ylim(y_limits);
yticks(y_ticks);
title('FDI inward flows in China (USD bn)', 'FontName', 'SansSerif');
source_text = 'Source: State Administration of Foreign Exchange via CEIC';
annotation('textbox', [0.115, 0, 0.8, 0.05], 'String', source_text, 'FontSize', 8, 'HorizontalAlignment', 'left', 'LineStyle', 'none', 'FontName', 'SansSerif');
set(gca, 'FontName', 'SansSerif');