function class = ClassifyX1(input, parameters)
%% K-NearestNeighbours

% Initialise counts for test data labels and total number of each label in training data
NN = 5;

for i = 1:length(input) %For all test data  
    for ii = 1:length(parameters.train_data) %For all training data
        distance2neighbours(i) = sqrt(sum((input(i,:) - parameters.train_data(ii,:)).^2)); %distance from test to training data 
            %if the closest neighbours isn't fully populated with NN entries, this is one of the NN closest neighbours
            if ii <= NN 
                closestNeighbours(ii,i) = distance2neighbours(i);
                closestNeighbours_label(ii,i) = parameters.train_labels(ii);
                test_labels(i) = mode(closestNeighbours_label(:,i),1);
            %elseif the distance is less than the maximum of the current
            %NN, replace the point and its corresponding label
            elseif distance2neighbours(i) < max(closestNeighbours(1:NN,i))
                [replace, replaceIndex] = max(closestNeighbours(1:NN,i));
                closestNeighbours(replaceIndex,i) = distance2neighbours(i);
                closestNeighbours_label(replaceIndex,i) = parameters.train_labels(ii);
                test_labels(i) = mode(closestNeighbours_label(:,i),1);
            end
    end
end 
figure
title([parameters.class1, ' and ', parameters.class2])
h = plot3(1,1,1,'ro');
hold on
h1 = plot3(1,1,1,'bo');
set(h,'Visible','off')
set(h1,'Visible','off')
xlabel('x')
ylabel('y')
zlabel('z')
for i = 1:length(input)
    if test_labels(i) == 1
        plot3(input(i,1),input(i,2),input(i,3), 'o', 'MarkerEdgeColor', [1 0 0])
    else
        plot3(input(i,1),input(i,2),input(i,3), 'o', 'MarkerEdgeColor', [0 0 1])    
    end
end
grid on
hold off
title([parameters.class1, ' and ', parameters.class2])
lgd = legend([h, h1],{[parameters.class1], [parameters.class2]},'TextColor','k','location', 'best');

class = test_labels';
end


