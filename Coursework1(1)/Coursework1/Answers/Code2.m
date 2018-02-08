clc
clear all
close all

tic

% Load properties data and determine number of test data points.
load('london.mat')

% Filter the Data, allowing only realistically priced properties in London 
% to be considered
[Prices] = DataFilter(Prices, Tube);

% Locate personalised tube Stop
[TubeStop, TubeCoor] = personalisedTube(1092693);

% Define parameters for clustering and cross validation
testFolds = 6;
gridBoxes = 6;

% Create test and train data by taking some data
[paramloc] = TestTrainData(Prices.locationGood, Prices.rentGood, gridBoxes);

%Cross Validation
for i = 1:testFolds-1
    
    %% Train the algorythm
    [param] = trainRegressor(paramloc.trainlocation{i}(:,:), paramloc.trainrent{i}(:,:));
    
    % Training RMSE
    [valTrain] = testRegressor(paramloc.trainlocation{i}(:,:), param);
    RMSETrain(i) = sqrt(mean((valTrain - paramloc.trainrent{i}(:,1)).^2))
    
    %% Test results
    [val] = testRegressor(paramloc.testlocation{i}(:,:), param);

    %Calculate RMSE and update paramGood with params giving lowest
    %RMSE
    RMSETest(i) = sqrt(mean((val - paramloc.testrent{i}(:,1)).^2))
    [RMSEmax, RMSEindex] = max(RMSETest);
    if RMSEindex == length(RMSETest)
        paramGood = [];
        paramGood = param;
    end

figure
subplot(3,2,i)
hist((val - paramloc.testrent{i}(:,:)), 25)
grid on
axis([-5000 2000 0 600])
xlabel('Error (£)')
ylabel('Frequency')
title(['Histogram for RMSE = ' num2str(RMSETest(i))])

end
toc
% Heat map
 heatmapRent(@testRegressor, paramGood)