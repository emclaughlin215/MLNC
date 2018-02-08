function [param] = TestTrainData(in, out, gridBoxes)
testFolds = 6;

% Find location of furthest out properties
minLat = min(in(:,1));
maxLat = max(in(:,1));
minLong = min(in(:,2));
maxLong = max(in(:,2));

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
            muOut.mu(1,n) = latSplit(k);
            muOut.mu(2,n) = longSplit(m);
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
        muOut.mu(1,n) = (latSplit(k+1)+latSplit(k))/2;
        muOut.mu(2,n) = (longSplit(m+1)+longSplit(m))/2;
        k = k + 1;
        n = n + 1;
    end
    m = m + 1;
end

%Calculate the distant from each property to each gaussian
for i = 1:length(muOut.mu)
    Dist2Gaussian(:,i) = sqrt((in(:,1)-muOut.mu(1,i)).^2 + ((in(:,2)-muOut.mu(2,i)).^2));
end

% Find the closest gaussian to each property
for i = 1:length(in(:,1))
    [minDist(i), minIndex(i)] = min(Dist2Gaussian(i,:));
end

% Allocate properties to each gaussian based on the minumum distances from
% properties to gaussians
for i = 1:length(muOut.mu)
    GaussiansProps = zeros(length(in(minIndex(:) == i ,1)),2);
    GaussiansProps_Rent = zeros(length(in(minIndex(:) == i ,1)),1);
    GaussiansProps(:,1) = in(minIndex(:) == i ,2);
    GaussiansProps(:,2) = in(minIndex(:) == i ,1);
    GaussiansProps_Rent(:) = out(minIndex(:) == i);
    muOut.GaussProps{i}(:,:) = zeros(length(GaussiansProps(:,1)),3);
    muOut.GaussProps{i}(:,:) = [GaussiansProps(:,2),GaussiansProps(:,1),GaussiansProps_Rent(:)];
end

% Split the properties into training and test data
for i = 1:(testFolds-1)
    param.testlocation{i} = [];
    param.testrent{i} = [];
    param.trainlocation{i} = [];
    param.trainrent{i} = [];
    for ii = 1:length(muOut.mu)
        randomIndex = randperm(length(muOut.GaussProps{ii}(:,1)));
        lengthA = round((length(muOut.GaussProps{ii}(:,1))/testFolds));
        % If loop to take care of errors for small value of lengthA
        if lengthA == 1
            dummyVarA = randomIndex(1);
            param.testlocation{i}(1,1:2) = muOut.GaussProps{ii}(dummyVarA,1:2);
            param.testrent{i}(1,1) = muOut.GaussProps{ii}(dummyVarA,3);
            dummyVarB = zeros(1,length(randomIndex-lengthA));
            dummyVarB = randomIndex(2:i-1);
            lengthB = length(muOut.GaussProps{ii}(dummyVarB,1));
            param.trainlocation{i}(end+1:end+lengthB,1:2) = muOut.GaussProps{ii}(dummyVarB,1:2);
            param.trainrent{i}(end+1:end+lengthB,1) = muOut.GaussProps{ii}(dummyVarB,3);
        elseif lengthA == 0
            dummyVarB = 1:length(muOut.GaussProps{ii}(:,1));
            dummyVarB(randomIndex(((i-1)*lengthA+1):i*lengthA)) = [];
            lengthB = length(muOut.GaussProps{ii}(dummyVarB,1));
            param.trainlocation{i}(end+1:end+lengthB,1:2) = muOut.GaussProps{ii}(dummyVarB,1:2);
            param.trainrent{i}(end+1:end+lengthB,1) = muOut.GaussProps{ii}(dummyVarB,3);
        else
            dummyVarA = randomIndex(((i-1)*lengthA+1):i*lengthA);
            param.testlocation{i}(end+1:end+lengthA,1:2) = muOut.GaussProps{ii}(dummyVarA,1:2);
            param.testrent{i}(end+1:end+lengthA,1) = muOut.GaussProps{ii}(dummyVarA,3);
            dummyVarB = 1:length(muOut.GaussProps{ii}(:,1));
            dummyVarB(randomIndex(((i-1)*lengthA+1):i*lengthA)) = [];
            lengthB = length(muOut.GaussProps{ii}(dummyVarB,1));
            param.trainlocation{i}(end+1:end+lengthB,1:2) = muOut.GaussProps{ii}(dummyVarB,1:2);
            param.trainrent{i}(end+1:end+lengthB,1) = muOut.GaussProps{ii}(dummyVarB,3);
        end
    end
end

end