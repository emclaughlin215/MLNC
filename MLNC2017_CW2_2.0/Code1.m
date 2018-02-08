clear all
load activities.mat

% labels - ID of the activity 
% 1 - walking
% 2 - running
% 3 - walking upstairs
% 4 - walking downstairs
tic

 class1 = input('Class 1');
 class2 = input('Class 2');
 
if class1 == 1
    CLASS1 = 'Walking';
elseif class1 == 2
    CLASS1 = 'Running';
elseif class1 == 3
    CLASS1 = 'UpStairs';
elseif class1 == 4  
    CLASS1 = 'DownStairs';
end

if class2 == 1
    CLASS2 = 'Walking';
elseif class2 == 2
    CLASS2 = 'Running';
elseif class2 == 3
    CLASS2 = 'UpStairs';
elseif class2 == 4  
    CLASS2 = 'DownStairs';
end
        
%% Create Data Split for Two Labels.
[train_bimodal, train_bimodal_labels, test_bimodal, test_bimodal_labels] = ...
    bimodalData(train_data, train_labels, test_data, test_labels, class1, class2);

%% K-NN Classifier
% parameters.train_data = train_bimodal;
% parameters.train_labels = train_bimodal_labels;
% parameters.class1 = CLASS1;
% parameters.class2 = CLASS2;
% class = ClassifyX1(test_bimodal, parameters);

%% Gaussian Mixture Model
parameters = TrainClassifierX(train_bimodal, train_bimodal_labels);
parameters.class1 = CLASS1;
parameters.class2 = CLASS2;
for i = 1:length(test_bimodal)
    class(i,1) = ClassifyX(test_bimodal(i,:), parameters);
end

%% Accuracy Calculator & Plotter

accuracy = sum(sum(class == test_bimodal_labels, 2) == 1)/length(test_bimodal_labels);

count11 = 0;
count12 = 0;
count21 = 0;
count22 = 0;
num1 = length(test_bimodal_labels(test_bimodal_labels == 1));
num2 = length(test_bimodal_labels(test_bimodal_labels == 2));
for i = 1:length(test_bimodal)
    if class(i,1) == 1 && test_bimodal_labels(i,1) == 1
        count11 = count11 + 1;
        CM(1,1) = count11 / num1;
    elseif class(i,1) == 1 && test_bimodal_labels(i,1) == 2
        count12 = count12 + 1;
        CM(1,2) = count12 / num2;
    elseif class(i,1) == 2 && test_bimodal_labels(i,1) == 1
        count21 = count21 + 1;
        CM(2,1) = count21 / num1;
    else
        count22 = count22 + 1;
        CM(2,2) = count22 / num2;
    end
end
descr = {'Confusion Matrix';
    num2str(CM)};
title(legend, descr)
sprintf('Class %s and class %s, give an accuracy of...', CLASS1, CLASS2)
CM
accuracy
toc
