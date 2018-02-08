function heatmapRent(testRegressor, params)

lat = linspace(51.3, 51.69, 400)';
long = linspace(-0.510, 0.2, 400)';
[LAT,LON] = meshgrid(lat,long);
rent = testRegressor([reshape(LAT, 400^2, 1),reshape(LON, 400^2, 1)], params);
% colormap('hot');
% imagesc(reshape(rent, 30, 30));
% set(gca, 'XTick', linspace(1,900), 'XTickLabel', lat)
% set(gca, 'YTick', linspace(1,900), 'YTickLabel', long)
% xlabel('Latitude')
% ylabel('Longtitude')
rent = reshape(rent, 400, 400);
figure
surf(LON,LAT,rent)

colormap('jet');
surf(LON,LAT,rent);
shading interp
view
xlabel('Longitude [^\circ]')
ylabel('Latitude [^\circ]')
% xlim([-0.510 0.2])
% ylim([51.30 51.69])
view(0,90)
hcb=colorbar
title(hcb,'PCM [£]')

end