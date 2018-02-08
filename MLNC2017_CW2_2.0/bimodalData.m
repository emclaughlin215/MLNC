function [train_bimodal, train_bimodal_labels, test_bimodal, test_bimodal_labels] = bimodalData(train_data, train_labels, test_data, test_labels, group1, group2)

%extrac all the points and labels of the given classes from test and train
%datasets
bimodal_train_index = find(train_labels == group1 | train_labels == group2);
train_bimodal = train_data(bimodal_train_index, :);
train_bimodal_labels = train_labels(bimodal_train_index);
bimodal_test_index = find(test_labels == group1 | test_labels == group2);
test_bimodal = test_data(bimodal_test_index, :);
test_bimodal_labels = test_labels(bimodal_test_index);

%reallcoate the class number 1 and 2 to the chosen classes for train
%dataset
minTB = min(train_bimodal_labels);
index_minTB = find(train_bimodal_labels == minTB);
train_bimodal_labels(index_minTB) = train_bimodal_labels(index_minTB) - minTB + 1;
maxTB = max(train_bimodal_labels);
index_maxTB = find(train_bimodal_labels == maxTB);
train_bimodal_labels(index_maxTB) = train_bimodal_labels(index_maxTB) - maxTB + 2;

%reallcoate the class number 1 and 2 to the chosen classes for test
%dataset
minTestB = min(test_bimodal_labels);
index_minTestB = find(test_bimodal_labels == minTestB);
test_bimodal_labels(index_minTestB) = test_bimodal_labels(index_minTestB) - minTestB + 1;
maxTestB = max(test_bimodal_labels);
index_maxTestB = find(test_bimodal_labels == maxTestB);
test_bimodal_labels(index_maxTestB) = test_bimodal_labels(index_maxTestB) - maxTestB + 2;

end