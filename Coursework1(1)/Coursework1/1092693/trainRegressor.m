function [param] = trainRegressor(in, out)

%Grid Boxes selected
gridBoxes = 6;

% Based on TRAINING data only, estimate the location and variance of
% gaussians
[muOut, stdOut] = GaussianLocateTrain(in, out, gridBoxes);
numGaussians = length(muOut.mu);

baseFuncs=cell(numGaussians+1,1);
% Initialising variables
for i=1:numGaussians
    % Fill your mean (mu) and variance (sig) here
    %===========================================%
    mu = muOut.mu(1:2,i)';
    sig(1:2,1:2) = stdOut(:,:,i);
    %===========================================%
    baseFuncs{i}=@(x)myGaussian(x,mu,sig);
    param.mu{i}=mu;
    param.sig{i}=sig;
end

baseFuncs{end}=@(x)1;
%calculate the values of each basis function at each training datapoint
val=zeros(length(in),length(baseFuncs));
for i=1:length(in)
    valTemp=zeros(1,length(baseFuncs));
    for j=1:length(baseFuncs)
        valTemp(1,j)=baseFuncs{j}(in(i,:));
    end
    val(i,:)=valTemp;
end
%pseudoinverse for least squares solution
param.w=pinv(val)*out;
param.baseFuncs=baseFuncs;
end

function val=myGaussian(x,mu,sig)
%a gaussian basis function
val=exp(-(x-mu)*pinv(sig)*(x-mu)');
end

function [mu, GaussVar] = GaussianLocateTrain(Prices_locationGood, Prices_rentGood, gridBoxes)

% Find location of furthest out properties
minLat = min(Prices_locationGood(:,1));
maxLat = max(Prices_locationGood(:,1));
minLong = min(Prices_locationGood(:,2));
maxLong = max(Prices_locationGood(:,2));

% Create a grid based on the number of gridboxes specified
xy = divisors(gridBoxes);
if mod(sqrt(gridBoxes),1) == 0 %If a square number
        XY = length(xy)/2 + 0.5;
    elseif mod(length(xy),2) == 0 %If number of divisors is even
        XY = length(xy)/2;
    else
        XY = length(xy)/2 - 0.5; %If number of divisors is odd
end
nx = xy(XY);
ny = gridBoxes/nx;

% Create a spread of Gaussians based on the grid
longSplit = linspace(minLong,maxLong,nx);
latSplit = linspace(minLat,maxLat,ny);
n = 1;
m = 1;
% Place a Gaussian on the intersection of each grid line
while m <= nx
    k = 1;
    while k <= ny
            mu.mu(1,n) = latSplit(k);
            mu.mu(2,n) = longSplit(m);
            n = n + 1;
        k = k + 1;
    end
    m = m + 1;
end
% Place a Gaussian in the middle of eahc grid box
m = 1;
while m <= nx-1
    k = 1;
    while k <= ny-1
        mu.mu(1,n) = (latSplit(k+1)+latSplit(k))/2;
        mu.mu(2,n) = (longSplit(m+1)+longSplit(m))/2;
        k = k + 1;
        n = n + 1;
    end
    m = m + 1;
end


weightedLat = zeros(length(mu.mu),2);
weightedLong = zeros(length(mu.mu),2);
delta = zeros(2,1);
weightedLong(:,1) = mu.mu(2,:);
weightedLat(:,1) = mu.mu(1,:);
delta(1) = sum(sqrt((weightedLong(:,2)-weightedLong(:,1)).^2 + (weightedLat(:,2)-weightedLat(:,1)).^2))/length(mu);
n = 1;
GaussVar(:,:,1:length(mu.mu)) = zeros(2,2,length(mu.mu));
while abs(delta(2) - delta(1)) > 0.0005
    % Remove Gaussians with less than 2500/gridBoxes within half a standard
    % deviation of the centre of the gaussian
    diffLat = 5*(latSplit(2)-latSplit(1));
    diffLong = 5*(longSplit(2)-longSplit(1));
    std = max(diffLat, diffLong);
    dist2point = sqrt((Prices_locationGood(:,1) - mu.mu(1,:)).^2 + (Prices_locationGood(:,2) - mu.mu(2,:)).^2);
    for i = 1:((nx*ny-4)+(nx-1)*(ny-1))
        if length(dist2point((dist2point(:,i) < std))) < 2000/gridBoxes
            mu.mu(1,i) = 0;
        end
    end
    
    for i = 1:length(mu.mu)
        Dist2Gaussian(:,i) = sqrt((Prices_locationGood(:,1)-mu.mu(1,i)).^2 + ((Prices_locationGood(:,2)-mu.mu(2,i)).^2));
    end

    for i = 1:length(Prices_locationGood(:,1))
        [minDist(i), minIndex(i)] = min(Dist2Gaussian(i,:));
    end
    
        for i = 1:length(mu.mu)
            GaussiansProps = zeros(length(Prices_locationGood(minIndex(:) == i ,1)),2);
            GaussiansProps_Rent = zeros(length(Prices_locationGood(minIndex(:) == i ,1)),1);
            GaussiansProps_RentNorm = zeros(length(Prices_locationGood(minIndex(:) == i ,1)),1);
            GaussiansProps(:,1) = Prices_locationGood(minIndex(:) == i ,1);
            GaussiansProps(:,2) = Prices_locationGood(minIndex(:) == i ,2);
            GaussiansProps_Rent(:) = Prices_rentGood(minIndex(:) == i);
            GaussiansProps_RentNorm(:) = GaussiansProps_Rent(:)/max(GaussiansProps_Rent(:));
            if isempty(GaussiansProps_Rent(:))
                mu.mu(1,i) = 0;
            else
                weightedLat(i,2) = weightedLat(i,1);
                weightedLong(i,2) = weightedLong(i,1);
                weightedLat(i,1) = sum(GaussiansProps(:,1).*GaussiansProps_RentNorm(:))./sum(GaussiansProps_RentNorm(:));
                weightedLong(i,1) = sum(GaussiansProps(:,2).*GaussiansProps_RentNorm(:))./sum(GaussiansProps_RentNorm(:));
                mu.mu(1,i) = weightedLat(i,1);
                mu.mu(2,i) = weightedLong(i,1);
                GaussVar(1:2, 1:2, i) = cov(GaussiansProps(:,2), GaussiansProps(:,1));
                figure(3)
                if n>1
                    delete(H(i,n-1))
                end
                H(i,n) = plot(GaussiansProps(:,2),GaussiansProps(:,1),'o');
                hold on
            end
        end
delta(2) = delta(1);
delta(1) = sum(sqrt((weightedLong(:,2)-weightedLong(:,1)).^2 + (weightedLat(:,2)-weightedLat(:,1)).^2))/length(mu.mu);
n = n + 1;
pause(0.1)
end

GaussVar = GaussVar(:,:,(mu.mu(1,:) > 0));
mu.mu = mu.mu(:,(mu.mu(1,:) > 0));

overall_weighted_long = sum((Prices_locationGood(:,2).*Prices_rentGood(:)))/sum(Prices_rentGood(:));
overall_weighted_lat = sum((Prices_locationGood(:,1).*Prices_rentGood(:)))/sum(Prices_rentGood(:));
overall_cov = cov(Prices_locationGood(:,2),Prices_locationGood(:,1));
mu.mu(:,end+1) = [overall_weighted_lat, overall_weighted_long];
GaussVar(:,:,end+1) = overall_cov;

fprintf('Number of Guassians = %d', length(mu.mu))

% Plot the remaining Gaussians on the same axis as the properties and tube
% map
figure(1)
hold on
plot(mu.mu(2,:),mu.mu(1,:),'*', 'MarkerSize', 20)

% Plot properties and tube map
figure(3)
plot(mu.mu(2,:),mu.mu(1,:),'*', 'MarkerSize', 20)
grid on
hold off
xlabel('Longitude')
ylabel('Latitude')
zlabel('Price')

end