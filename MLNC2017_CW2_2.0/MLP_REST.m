% This code is based on:
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Multilayer Perceptron (MLP) Neural Network Function using MATLAB:       %
%  An implementation for Multilayer Perceptron Feed Forward Fully         %
%  Connected Neural Network with a sigmoid activation function. The       %
%  training is done using the Backpropagation algorithm with options for  %
%  Resilient Gradient Descent, Momentum Backpropagation, and Learning     %
%  Rate Decrease. The training stops when the Mean Square Error (MSE)     %
%  reaches zero or a predefined maximum number of epochs is reached.      %
%                                                                         %
%  Four example data for training and testing are included with the       %
%  project. They are generated by SharkTime Sharky Neural Network         %
%   (http://sharktime.com/us_SharkyNeuralNetwork.html)                    %
%                                                                         %
% Copyright (C) 9-2015 Hesham M. Eraqi. All rights reserved.              %
%                    hesham.eraqi@gmail.com                               %
%                                                                         %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This code is based on the resilient gradient descent backpropagation.
%
function [accuracy, best_prediction] = MLP_REST(train_samples, train_labels, test_samples, test_labels, nbrOfNeuronsInEachHiddenLayer,nbrOfEpochs_max)

%% Data preprocessing

% Reformat class labels into binary code.
% Each row of TargetClasses corresponds to one datapoint.
% Each column number corresponds to one class.
% 1 - datapoint belongs to the given class
% 0 - datapoint does not belong to the given class

number_of_classes = size(unique(train_labels),1);

TargetClasses = zeros(size(train_samples,1),number_of_classes);

for i = 1:size(TargetClasses,1)
   TargetClasses(i,train_labels(i)) = 1;
end

%% Additional parameters (do not modify)
% Size of the output layer
nbrOfOutUnits = size(TargetClasses,2);

% Type of the sigmoid activation function
unipolarBipolarSelector = 0;

% Resilient gradient descent
enable_resilient_gradient_descent = 1; %1 for enable, 0 for disable
learningRate_plus = 1.2;
learningRate_negative = 0.5;
deltas_start = 0.9;
deltas_min = 10^-6;
deltas_max = 50;

%% Calculate Number of Input and Output NodesActivations (do not modify)
nbrOfInputNodes = length(train_samples(1,:));

nbrOfLayers = 2 + length(nbrOfNeuronsInEachHiddenLayer);
nbrOfNodesPerLayer = [nbrOfInputNodes nbrOfNeuronsInEachHiddenLayer nbrOfOutUnits];

%% Adding the Bias as Nodes with a fixed Activation of 1 (do not modify)
nbrOfNodesPerLayer(1:end-1) = nbrOfNodesPerLayer(1:end-1) + 1;
train_samples = [ones(length(train_samples(:,1)),1) train_samples];
test_samples = [ones(length(test_samples(:,1)),1) test_samples];

%% Initialize Random Weights Matrices (do not modify)
Weights = cell(1, nbrOfLayers); %Weights connecting bias nodes with previous layer are useless, but to make code simpler and faster
Delta_Weights = cell(1, nbrOfLayers);
ResilientDeltas = Delta_Weights; % Needed in case that Resilient Gradient Descent is used
for i = 1:length(Weights)-1
    Weights{i} = 2*rand(nbrOfNodesPerLayer(i), nbrOfNodesPerLayer(i+1))-1; %RowIndex: From Node Number, ColumnIndex: To Node Number
    Weights{i}(:,1) = 0; %Bias nodes weights with previous layer (Redundant step)
    Delta_Weights{i} = zeros(nbrOfNodesPerLayer(i), nbrOfNodesPerLayer(i+1));
    ResilientDeltas{i} = deltas_start*ones(nbrOfNodesPerLayer(i), nbrOfNodesPerLayer(i+1));
end
Weights{end} = ones(nbrOfNodesPerLayer(end), 1); %Virtual Weights for Output Nodes
Old_Delta_Weights_for_Resilient = Delta_Weights;

NodesActivations = cell(1, nbrOfLayers);
for i = 1:length(NodesActivations)
    NodesActivations{i} = zeros(1, nbrOfNodesPerLayer(i));
end
NodesBackPropagatedErrors = NodesActivations; %Needed for Backpropagation Training Backward Pass

zeroRMSReached = 0;
%% Iterating all the Data (do not modify)

MSE = -1 * ones(nbrOfEpochs_max,nbrOfOutUnits);
accuracy = zeros(nbrOfEpochs_max,1);
best_accuracy = 0;

for Epoch = 1:nbrOfEpochs_max
    
    for Sample = 1:length(train_samples(:,1))
        %% Backpropagation Training (do not modify)
        %Forward Pass
        NodesActivations{1} = train_samples(Sample,:);
        for Layer = 2:nbrOfLayers
            NodesActivations{Layer} = NodesActivations{Layer-1}*Weights{Layer-1};
            NodesActivations{Layer} = Activation_func(NodesActivations{Layer}, unipolarBipolarSelector);
            if (Layer ~= nbrOfLayers) %Because bias nodes don't have weights connected to previous layer
                NodesActivations{Layer}(1) = 1;
            end
        end
        
        % Backward Pass Errors Storage
        % (As gradient of the bias nodes are zeros, they won't contribute to previous layer errors nor delta_weights)
        NodesBackPropagatedErrors{nbrOfLayers} =  TargetClasses(Sample,:)-NodesActivations{nbrOfLayers};
        for Layer = nbrOfLayers-1:-1:1
            gradient = Activation_func_drev(NodesActivations{Layer+1}, unipolarBipolarSelector);
            for node=1:length(NodesBackPropagatedErrors{Layer}) % For all the Nodes in current Layer
                NodesBackPropagatedErrors{Layer}(node) =  sum( NodesBackPropagatedErrors{Layer+1} .* gradient .* Weights{Layer}(node,:) );
            end
        end
        
        % Backward Pass Delta Weights Calculation (Before multiplying by learningRate)
        for Layer = nbrOfLayers:-1:2
            derivative = Activation_func_drev(NodesActivations{Layer}, unipolarBipolarSelector);    
            Delta_Weights{Layer-1} = Delta_Weights{Layer-1} + NodesActivations{Layer-1}' * (NodesBackPropagatedErrors{Layer} .* derivative);
        end
    end
    
    %% Apply a resilient form of gradient descent or/and momentum to the delta_weights (do not modify)
    if (enable_resilient_gradient_descent) % Handle Resilient Gradient Descent
        for Layer = 1:nbrOfLayers-1
            mult = Old_Delta_Weights_for_Resilient{Layer} .* Delta_Weights{Layer};
            ResilientDeltas{Layer}(mult > 0) = ResilientDeltas{Layer}(mult > 0) * learningRate_plus; % Sign didn't change
            ResilientDeltas{Layer}(mult < 0) = ResilientDeltas{Layer}(mult < 0) * learningRate_negative; % Sign changed
            ResilientDeltas{Layer} = max(deltas_min, ResilientDeltas{Layer});
            ResilientDeltas{Layer} = min(deltas_max, ResilientDeltas{Layer});

            Old_Delta_Weights_for_Resilient{Layer} = Delta_Weights{Layer};

            Delta_Weights{Layer} = sign(Delta_Weights{Layer}) .* ResilientDeltas{Layer};
        end
    end

    %% Backward Pass Weights Update (do not modify)
    for Layer = 1:nbrOfLayers-1
        Weights{Layer} = Weights{Layer} + Delta_Weights{Layer};
    end
    
    % Resetting Delta_Weights to Zeros
    for Layer = 1:length(Delta_Weights)
        Delta_Weights{Layer} = 0 * Delta_Weights{Layer};
    end
    
    %% Evaluation (do not modify)
    
    number_of_classes = size(unique(test_labels),1);

    TestClasses = zeros(size(test_samples,1),number_of_classes);
    PredictedClasses = -1*ones(size(TestClasses));

    for i = 1:size(TestClasses,1)
       TestClasses(i,test_labels(i)) = 1;
    end
    
    for Sample = 1:length(test_samples(:,1))
        outputs = EvaluateNetwork(test_samples(Sample,:), NodesActivations, Weights, unipolarBipolarSelector);
        PredictedClasses(Sample,:) = double(outputs == max(outputs));
        % Prevention from multiple 1 outputs
        % Randomly choose 1 of them if it happens
        if sum(PredictedClasses(Sample,:)) > 1
            idx_tmp = datasample(find(PredictedClasses(Sample,:)==1),1);
            PredictedClasses(Sample, :) = zeros(size(PredictedClasses(Sample, :)));
            PredictedClasses(Sample, idx_tmp) = 1;
        end
    end
    
    MSE(Epoch,:) = sum((PredictedClasses-TestClasses).^2)/(length(test_samples(:,1)));
    accuracy(Epoch) = sum(sum(PredictedClasses == TestClasses, 2) == nbrOfOutUnits)/size(TestClasses,1);
    
    if ((sum(MSE(Epoch,:) == zeros(1,nbrOfOutUnits)) == 1) || (accuracy(Epoch) == 1))
        zeroRMSReached = 1;
    end
    
    %% Display results of each epoch

    disp([int2str(Epoch) ' Epochs done out of ' int2str(nbrOfEpochs_max) ' Epochs. Accuracy = ' num2str(mean(accuracy(Epoch)))]);
    
    %% Results
    
    % best_accuracy - best averaged accuracy achieved by the classifier
    % best_output - binary-coded output obtained from epoch that yielded
    % the highest accuracy
    % best_prediction - integer-coded predicted labels for each datapoint.
    % This can be directly compared with target_labels.
    
    if accuracy(Epoch) > best_accuracy
        best_accuracy = accuracy(Epoch);
        best_prediction = zeros(size(test_samples,1),1);
        for i = 1:size(test_samples,1)
            best_prediction(i) = find(PredictedClasses(i,:) == 1);
        end
    end
    
    %% Stopping criterion
    
    if (zeroRMSReached)
        break;
    end
    
end


%% Activation Function
function fx_drev = Activation_func_drev(fx, unipolarBipolarSelector)
    if (unipolarBipolarSelector == 0)
        fx_drev = fx .* (1 - fx); %Binary
    else
        fx_drev = 0.5 .* (1 + fx) .* (1 - fx); %Bipolar
    end
end

%% Activation Function
function fx = Activation_func(x, unipolarBipolarSelector)
    if (unipolarBipolarSelector == 0)
        fx = 1./(1 + exp(-x)); %Binary
    else
        fx = -1 + 2./(1 + exp(-x)); %Bipolar
    end
end

function outputs = EvaluateNetwork(Sample, NodesActivations, Weights, unipolarBipolarSelector)

nbrOfLayers = length(NodesActivations);

NodesActivations{1} = Sample;
for Layer = 2:nbrOfLayers
    NodesActivations{Layer} = NodesActivations{Layer-1}*Weights{Layer-1};
    NodesActivations{Layer} = Activation_func(NodesActivations{Layer}, unipolarBipolarSelector);
    if (Layer ~= nbrOfLayers) %Because bias nodes don't have weights connected to previous layer
        NodesActivations{Layer}(1) = 1;
    end
end

outputs = NodesActivations{end};

end

end
