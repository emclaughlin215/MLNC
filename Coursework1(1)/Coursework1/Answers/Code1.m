clc
clear all
close all

load('london.mat')

[Prices_locationGood, Prices_rentGood] = DataFilter(Prices, Tube);

mu1 = mean(Prices_locationGood(:,1));
mu2 = mean(Prices_locationGood(:,2));

Dist2centre = sqrt((Prices_locationGood(:,1) - mu1).^2 +(Prices_locationGood(:,2) - mu2).^2);
[Maxdist, IndexMaxDist] = max(Dist2centre);
areaTotal = pi*Maxdist^2;
R(1) = areaTotal / sqrt(7);

for i = 2:7
   R(i) = sqrt(i)*R(1);
end

location_temp = Prices_locationGood;
rent_temp = Prices_rentGood;
dist_temp = Dist2centre;
propertyZones = zeros(length(location_temp),3,7);
for i = 1:7
        propertyZones(1:length(location_temp(dist_temp < R(i),:)),1:2,i) = location_temp(dist_temp < R(i),:);
        propertyZones(1:length(location_temp(dist_temp < R(i),:)),3,i) =  rent_temp(dist_temp < R(i),:);
        location_temp = location_temp(dist_temp >= R(i),:);
        rent_temp = rent_temp(dist_temp >= R(i),1);
        dist_temp = dist_temp(dist_temp >= R(i));
end

figure(1)
plot3(Prices_locationGood(:,1),Prices_locationGood(:,2),Prices_rentGood(:,1),'o')
hold on
tubeheight(1:length(Tube.location(:,1)),1:length(Tube.location(:,1))) = 1;
plot3(Tube.location(:,1), Tube.location(:,2), tubeheight(:,:), 'ro')
x = 0:0.01:2;
for i = 1:7
    plot(mu1 + R(i).*cos(x.*pi),mu2 + R(i).*sin(x.*pi))
end
grid on
    













% mu = mean(Prices_location);
% mu1 = mu(1);
% mu2 = mu(2);
% muRent = mean(Prices_rent);
% 
% standardDev = std(Prices_location);
% std1 = standardDev(1);
% std2 = standardDev(2);
% stdRent = std(Prices_rent);
% locTruncation1 = 5;
% locTruncationRent = 10;
% 
% for i=1:1:length(Prices_location(:,1))
%     if abs(Prices_location(i,1)) > mu1 + locTruncation1*std1 ||...
%             abs(Prices_location(i,1)) < mu1 - locTruncation1*std1 ||...
%             abs(Prices_location(i,2)) > mu2 + locTruncation2*std2 ||...
%             abs(Prices_location(i,2)) < mu2 - locTruncation2*std2 %||...
%             %abs(Prices_rent(i,1)) > muRent + locTruncationRent*stdRent
%        Prices_location(i,1) = 0;
%        Prices_location(i,2) = 0;
%     end
% end
% 
% Prices_locationGood = Prices_location((Prices_location(:,1) > 0),:);
% Prices_rentGood = Prices_rent((Prices_location(:,1) > 0),:);
% 
% figure(1)
% plot3(Prices_locationGood(:,1),Prices_locationGood(:,2),Prices_rentGood(:,1),'o')
% hold on
% tubeheight(1:length(Tube.location(:,1)),1:length(Tube.location(:,1))) = 1;
% plot3(Tube.location(:,1), Tube.location(:,2), tubeheight(:,:), 'ro')
% % img = imread('ZonesImage.jpg');
% % J = imrotate(img,180,'bilinear');
% % J = imresize(J,0.25);
% % % xImage = [51.2 51.8; 51.2 51.8];   %# The x data for the image corners
% % % yImage = [1 1; -1 -1];             %# The y data for the image corners
% % xImage = [51.8 51.8; 51.2 51.2];   %# The x data for the image corners
% % yImage = [1 -1; 1 -1];             %# The y data for the image corners
% % zImage = [0 0; 0 0];   %# The z data for the image corners
% % surf(xImage,yImage,zImage,...    %# Plot the surface
% %      'CData',J,...
% %      'FaceColor','texturemap');
% % hold off
% xlabel('x')
% ylabel('y')
% zlabel('z')
% grid on
% hold off

% axis square

% [X, Y] = meshgrid(Prices_locationGood(:,1), Prices_locationGood(:,2));
% Z = griddata(Prices_locationGood(:,1), Prices_locationGood(:,2),Prices_rentGood(:,1), X,Y);
% 
% figure(2)
% surf(X,Y,Z);

% https://i.pinimg.com/originals/b3/75/f6/b375f62a50de78182df6121ed5fa443c.jpg