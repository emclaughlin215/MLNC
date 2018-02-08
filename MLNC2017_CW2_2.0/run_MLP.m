clear all

%% Load Data
%
% data - readings from the accelerometer. Each column corresponds to 
% respectively X, Y and Z axis.
%
% labels - ID of the activity 
% 1 - walking
% 2 - running
% 3 - walking upstairs
% 4 - walking downstairs
%
% For binary classification you should change the labels of your chosen
% activities so there are only values 1 and 2. For example if you chose to
% classify walking upstairs and downstair you should change the labels 3
% and 4 to respectively 1 and 2 for binary classification to work
% correctly. When in doubt ask GTA.

load Activities.mat
tic
%% Configurations/Parameters

% Network's architecture.
% Each element of the vector is the number of neurons in each hidden layer.
% For example:
% [1] - 1 hidden layer with 1 neuron
% [2 3] - 2 hidden layers with 2 and 3 neurons respectively
% Default MLP architecture: [5]
    
% nbrOfNeuronsInEachHiddenLayerVec = [2 5 2;...
%                                     3 6 3;...
%                                     4 7 4];
%                                 
% nbrOfNeuronsInEachHiddenLayer = ...
%     nbrOfNeuronsInEachHiddenLayerVec(i,:);
    
nbrOfNeuronsInEachHiddenLayer1{1} = [12];
% nbrOfNeuronsInEachHiddenLayer1{2} = [12 12];
% nbrOfNeuronsInEachHiddenLayer1{3} = [12 12 12];
% nbrOfNeuronsInEachHiddenLayer1{4} = [3 3 3 3];
% nbrOfNeuronsInEachHiddenLayer1{5} = [2 2 2 2 2 2];
% 
nbrOfNeuronsInEachHiddenLayer = nbrOfNeuronsInEachHiddenLayer1{1};

% Epoch - one forward pass and one backward pass of all the training
% examples.
% Maximum number of epochs.
% Default number of epochs: 500.
nbrOfEpochs_max = 500;

%% Question 1A - How does the learning rate influence the training process?
% This is classic implementation of the backpropagation-based learning
% algorithm. All the methods in the function MLP_1A are covered in the
% lecture.
% Hint: You may have noticted that the learning is relatviely slow. You can
% try to run the code with more epochs to see at which epoch do the learning
% curves plateau. DON'T spend too much time on such experiments, as the
% process can be very time consuming. In the end you should report the
% results for 500 epochs.

% Learning rate
% Default learning rate: 0.0001
learningRateVec = [0.01, 0.001, 0.0005, 0.0001];
learningRate = learningRateVec(2);

% Should learning rate decrease with each epoch?
enable_decrease_learningRate = 0; %1 for enable decreasing, 0 for disable
learningRate_decreaseValue = 0.001*learningRate; % decrease value
min_learningRate = 0.000000005; % minimum learning rate

% [accuracy_1a, best_prediction_1a] = MLP_1A(train_data, train_labels, test_data, test_labels, nbrOfNeuronsInEachHiddenLayer, learningRate, nbrOfEpochs_max, enable_decrease_learningRate, learningRate_decreaseValue, min_learningRate);
% 
% accuracySmooth(:) = smooth(accuracy_1a,50);
% predWalk_1a_index = find(best_prediction_1a == 1);
% predRunning_1a_index = find(best_prediction_1a == 2);
% predWalkUp_1a_index = find(best_prediction_1a == 3);
% predWalkDown_1a_index = find(best_prediction_1a == 4);
% predWalk = train_data(predWalk_1a_index(:),:);
% predRunning = train_data(predRunning_1a_index(:),:);
% predWalkUp = train_data(predWalkUp_1a_index(:),:);
% predWalkDown = train_data(predWalkDown_1a_index(:),:);
% 
% figure(1)
% subplot(2,3,1)
% plot(1:size(accuracySmooth),accuracySmooth(:,i))
% hold on
% grid on
% title('Learning Curve')
% xlabel('Epoch')
% ylabel('Accuracy')
% subplot(2,3,(1+i))
% scatter3(predWalk(:,1),predWalk(:,2),predWalk(:,3))
% hold on
% scatter3(predRunning(:,1),predRunning(:,2),predRunning(:,3))
% scatter3(predWalkUp(:,1),predWalkUp(:,2),predWalkUp(:,3))
% scatter3(predWalkDown(:,1),predWalkDown(:,2),predWalkDown(:,3))
% title('Classification')
% xlabel('x-acc')
% ylabel('y-acc')
% zlabel('z-acc')
% grid on
% hold off
% 
% figure(1)
% plot(1:size(accuracySmooth),accuracySmooth(:))
% hold on
% % if i == 1
% %     plot((1:size(accuracy)), accuracy, 'b--')
% % end
% grid on
% title('Learning Curve')
% xlabel('Epoch')
% ylabel('Accuracy')


% accuracy_1a - [nbrOfEpochs_max x 1] vector of accuracies obtained for each
% of training epochs. So-called 'learning curve'.
 
% best_prediction_1a - [number of datapoints x 1] vector of predicted classes
% for each datapoint for the epoch that yielded the best accuracy. This can
% be directly compared with target_labels containing the true labels.

%% Rest of the questions
% Note that this function does not take learning rate as an input, as the 
% resilient gradient descent backpropagation (RPROP) is used in the training
% process. The reason for using it is better overall perfomance and much 
% faster runtimes.
 
% The original paper describing the method:
% Martin Riedmiller, 'Rprop -Description and Implementation Details', 
% Technical Report, January 1994

% [train_bimodal, train_bimodal_labels, test_bimodal, test_bimodal_labels] = ...
%     bimodalData(train_data, train_labels, test_data, test_labels, 2, 3);
% [accuracy, best_prediction] = MLP_REST(train_bimodal, train_bimodal_labels, test_bimodal, test_bimodal_labels, nbrOfNeuronsInEachHiddenLayer, nbrOfEpochs_max);

[accuracy, best_prediction] = MLP_REST(train_data, train_labels, test_data, test_labels, nbrOfNeuronsInEachHiddenLayer, nbrOfEpochs_max);

accuracySmooth(:) = smooth(accuracy,50);
predWalk_index = find(best_prediction == 1);
predRunning_index = find(best_prediction == 2);
predWalkUp_index = find(best_prediction == 3);
predWalkDown_index = find(best_prediction == 4);
predWalk = train_data(predWalk_index(:),:);
predRunning = train_data(predRunning_index(:),:);
predWalkUp = train_data(predWalkUp_index(:),:);
predWalkDown = train_data(predWalkDown_index(:),:);

% figure(1)
% % subplot(2,1,1)
% % plot(1:size(accuracySmooth),accuracySmooth(:))
% % hold on
% % grid on
% % title('Learning Curve')
% % xlabel('Epoch')
% % ylabel('Accuracy')
% % subplot(2,1,1)
% scatter3(predWalk(:,1),predWalk(:,2),predWalk(:,3))
% hold on
% scatter3(predRunning(:,1),predRunning(:,2),predRunning(:,3))
% scatter3(predWalkUp(:,1),predWalkUp(:,2),predWalkUp(:,3))
% scatter3(predWalkDown(:,1),predWalkDown(:,2),predWalkDown(:,3))
% title('Classification')
% xlabel('x-acc')
% ylabel('y-acc')
% zlabel('z-acc')
% grid on
% hold off

figure(2)
plot(1:length(accuracySmooth),accuracySmooth)
hold on
% if i == 1
%     plot((1:size(accuracy)), accuracy, 'b--')
% end
grid on
title('Learning Curve')
xlabel('Epoch Number')
ylabel('Accuracy')
% axis([0 750 0.45 0.7])
% lgd = legend('[12]', '[6]');
% title(lgd,'Hidden Neuron Layers')
% legend boxoff

count11 = 0;
count12 = 0;
count13 = 0;
count14 = 0;
count21 = 0;
count22 = 0;
count23 = 0;
count24 = 0;
count31 = 0;
count32 = 0;
count33 = 0;
count34 = 0;
count41 = 0;
count42 = 0;
count43 = 0;
count44 = 0;
num1 = length(test_labels(test_labels == 1));
num2 = length(test_labels(test_labels == 2));
num3 = length(test_labels(test_labels == 3));
num4 = length(test_labels(test_labels == 4));
for i = 1:length(test_data)
    if best_prediction(i) == 1 && test_labels(i) == 1
        count11 = count11 + 1;
        CM(1,1) = count11 / num1;
    elseif best_prediction(i) == 1 && test_labels(i) == 2
        count12 = count12 + 1;
        CM(1,2) = count12 / num2;
    elseif best_prediction(i) == 1 && test_labels(i) == 3
        count13 = count13 + 1;
        CM(1,3) = count13 / num3;
    elseif best_prediction(i) == 1 && test_labels(i) == 4
        count14 = count14 + 1;
        CM(1,4) = count14 / num4;
    elseif best_prediction(i) == 2 && test_labels(i) == 1
        count21 = count21 + 1;
        CM(2,1) = count21 / num1;
    elseif best_prediction(i) == 2 && test_labels(i) == 2
        count22 = count22 + 1;
        CM(2,2) = count22 / num2;
    elseif best_prediction(i) == 2 && test_labels(i) == 3
        count23 = count23 + 1;
        CM(2,3) = count23 / num3;
    elseif best_prediction(i) == 2 && test_labels(i) == 4
        count24 = count24 + 1;
        CM(2,4) = count24 / num4;
    elseif best_prediction(i) == 3 && test_labels(i) == 1
        count31 = count31 + 1;
        CM(3,1) = count31 / num1;
    elseif best_prediction(i) == 3 && test_labels(i) == 2
        count32 = count32 + 1;
        CM(3,2) = count32 / num2;
    elseif best_prediction(i) == 3 && test_labels(i) == 3
        count33 = count33 + 1;
        CM(3,3) = count33 / num3;
    elseif best_prediction(i) == 3 && test_labels(i) == 4
        count34 = count34 + 1;
        CM(3,4) = count34 / num4;
    elseif best_prediction(i) == 4 && test_labels(i) == 1
        count41 = count41 + 1;
        CM(4,1) = count41 / num1;
    elseif best_prediction(i) == 4 && test_labels(i) == 2
        count42 = count42 + 1;
        CM(4,2) = count42 / num2;
    elseif best_prediction(i) == 4 && test_labels(i) == 3
        count43 = count43 + 1;
        CM(4,3) = count43 / num3;
    elseif best_prediction(i) == 4 && test_labels(i) == 4
        count44 = count44 + 1;
        CM(4,4) = count44 / num4;
    end
end

toc

% accuracy - [nbrOfEpochs_max x 1] vector of accuracies obtained for each
% of training epochs. So-called 'learning curve'.
% 
% best_prediction - [number of datapoints x 1] vector of predicted classes
% for each datapoint for the epoch that yielded the best accuracy. This can
% be directly compared with target_labels containing the true labels.