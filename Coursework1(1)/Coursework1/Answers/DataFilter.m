function [Prices] = DataFilter(Prices, Tube)

% Filter the locations by longitude and latitude of London
Prices_location = Prices.location(( 51.30 < Prices.location(:,1) & Prices.location(:,1) < 51.69 &...
                 -0.510 < Prices.location(:,2) & Prices.location(:,2) < 0.2),:);
Prices_rent = Prices.rent(( 51.30 < Prices.location(:,1) & Prices.location(:,1) < 51.69 &...
                 -0.510 < Prices.location(:,2) & Prices.location(:,2) < 0.2),:);

% Filter out the extreme prices to remove outliers
muRent = mean(Prices_rent);
stdRent = std(Prices_rent);
for i=1:1:length(Prices_location(:,1))
    if abs((Prices_rent(i,1)) > 3500) || (abs(Prices_rent(i,1)) < 800)
       Prices_location(i,1) = 0;
    end
end
Prices.locationGood = Prices_location((Prices_location(:,1) > 0),:);
Prices.rentGood = Prices_rent((Prices_location(:,1) > 0),:);

% Plot properties and tube map
figure(1)
plot3(Prices.locationGood(:,2),Prices.locationGood(:,1),Prices.rentGood(:,1),'bo')
hold on
tubeheight(1:length(Tube.location(:,1)),1:length(Tube.location(:,1))) = 1;
plot3(Tube.location(:,2), Tube.location(:,1), tubeheight(:,:), 'ko')
grid on
xlabel('Longitude')
ylabel('Latitude')
zlabel('Price')

end