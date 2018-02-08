clear;
load Activities.mat
%Eliminate going upstairs and downstairs from the data (labels 3 and 4)
[I1,~,~]= find(train_labels==3);
train_data(I1,:)=[];
train_labels(I1,:)=[];
[I1,~,~]= find(test_labels==3);
test_data(I1,:)=[];
test_labels(I1,:)=[];
[I2,~,~]= find(train_labels==4);
train_data(I2,:)=[];
train_labels(I2,:)=[];
[I2,~,~]= find(test_labels==4);
test_data(I2,:)=[];
test_labels(I2,:)=[];
%%

classes= unique(train_labels);
numberOfClasses = length(classes);
% compute class probability
class_prob= zeros(1,length(classes));
for i=1:numberOfClasses
    class_prob(i)=sum(train_labels==classes(i))/length(train_labels);
end

% normal distribution computation from the training data
for i=1:numberOfClasses
    xi=train_data((train_labels==classes(i)),:);
    mu{i}=mean(xi,1);
    sigma{i}=cov(xi);
end

%%
% probability for test data

for j=1:length(test_data)
    %p(xi|C1)
    test_dist1= 1./((2*pi)^(1/2)*det(sigma{1})^(1/2)) * exp(-0.5*(test_data(j,:) - mu{1})*inv(sigma{1})*(test_data(j,:) - mu{1})');
    %p(xi|C2)
    test_dist2= 1./((2*pi)^(1/2)*det(sigma{2})^(1/2)) * exp(-0.5*(test_data(j,:) - mu{2})*inv(sigma{2})*(test_data(j,:) - mu{2})');
    
    test_dist= [test_dist1, test_dist2];
    % P(C1|xi) = p(c)*prod p(xi|Ck)
    product= prod(test_dist,2);
    Prob(j,:)=class_prob.*product;
 
end


% get predicted output for test set
[prediction_0, ind]= max(Prob,[],2);
for i=1:length(ind)
    prediction(i,1)= classes(ind(i));
end

%% 
%Confusion matrix computation 
classes=unique(test_labels);
confusionMatrix=zeros(length(classes));
for i=1:length(classes)
    for j=1:length(classes)
        confusionMatrix(i,j)=sum(test_labels==classes(i) & prediction==classes(j));
    end
end

for k= 1:length(confusionMatrix)
   confusionMatrix(k,:) = confusionMatrix(k,:)/sum(confusionMatrix(k,:));
end 


%Accuracy computation 
[I,~,~] =  find(test_labels == 1);
[I1,~,~] =  find(prediction == 1);
[I2,~,~] =  find(test_labels == 2);
[I3,~,~] =  find(prediction == 2);
%Correct prediction of class 1
[c1, ~,~]= intersect(I, I1);
%Correct prediction of class 2
[c2, ~,~]= intersect(I2, I3);

correctly_classified = length(c1)+length(c2);

accuracy= (correctly_classified/length(test_labels))*100;

%% plots

% Visualize the plot of walking and jogging prediction values. 
walking_naive=(test_data(I1,:));
jogging_naive=(test_data(I3,:));

figure;
scatter3(walking_naive(:,1),walking_naive(:,2),walking_naive(:,3),'filled');
hold on;
scatter3(jogging_naive(:,1),jogging_naive(:,2),jogging_naive(:,3),'filled');
legend('walking','jogging')
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Acceleration - Naive Bayes data');