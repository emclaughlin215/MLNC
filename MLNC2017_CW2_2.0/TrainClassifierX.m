function parameters = TrainClassifierX(input,output)

% Split data into two classes
maxclass = max(output(:,1));
minclass = min(output(:,1));
category{1} = input(output(:,1) == minclass,:);
category{2} = input(output(:,1) == maxclass,:);


% Place down x number of clusters for each category
x = 2;
mu{1}=[1 1 1;...
      0 5 10];
mu{2}=[1 1 1;...
      0 5 10];

% For each class, use k-means to appropriately cluster the 2 gaussians.
for k = 1:2
closestCluster = ones(length(category{k}),1);
muChange{k}(1:x) = ones(1,x);
    while sum(muChange{k}(1:end)) > 0.001 %convergence createria for k-means
        for i = 1:length(category{k})
            for ii = 1:x
                dist2cluster(ii) = sqrt(sum((category{k}(i,:) - mu{k}(ii,:)).^2));
            end
            [~, mindistindex] = min(dist2cluster(:));
            closestCluster(i) = mindistindex;
        end 
        for i = 1:x
            index_data = [];
            index_data = find(closestCluster == i);
            cluster_data{k}{i} = zeros(length(index_data),3);
            cluster_data{k}{i}(:,1:3) = category{k}(index_data, 1:3);
            muOLD{k}(:,1:3) = mu{k};
            mu{k}(i,1:3) = [mean(cluster_data{k}{i}(:,1)), mean(cluster_data{k}{i}(:,2)), mean(cluster_data{k}{i}(:,3))];
            muChange{k}(i) = sqrt(sum((mu{k}(i,:) - muOLD{k}(i,:)).^2));
            parameters.mu{k}(:,:) = mu{k}(:,:);
            sigmaGauss{k}(:,:,i) = cov(cluster_data{k}{i}(:,:)); %calulate gaussian covar
        end
    end
end

for k = 1:2 %consider each class one at a time
    muChange{k}(1:x) = ones(1,x); %reset the initial muChange for the new class
    while sum(muChange{k}(1:end)) > 0.001 %convergence criteria
        muOLD{k} = parameters.mu{k};
        %taking each guassian one at a time
        %calculate the probability each that of the data points belongs
        %to the given guassian
        for ii = 1:x
            for i = 1:length(category{k})
                P{k}(i,ii) = 1./((2*pi)^(3/2)*det(sigmaGauss{k}(:,:,ii))^(1/2)) * ...
                    exp(-0.5*(category{k}(i,:) - parameters.mu{k}(ii,:))*inv(sigmaGauss{k}(:,:,ii))*(category{k}(i,:) - parameters.mu{k}(ii,:))');
            end     
        end
        %normalise the probability
        for ii = 1:x
            probdata2Gauss{k}(:,ii) = [P{k}(:,ii)./sum(P{k}(:,:),2)];
        end
        %find the gaussian the data point most likely belongs to
        [~, maxprobindex] = max(probdata2Gauss{k}(:,:),[],2);
        %calculate all the data which belong to each gaussian
        for ii = 1:x
            thisGauss = find(maxprobindex == ii);
            %calculate the new gaussian positions and covar matrices
            for j = 1:3
                parameters.mu{k}(ii,j) = probdata2Gauss{k}(thisGauss,ii)'*category{k}(thisGauss,j)/sum(probdata2Gauss{k}(thisGauss,ii));
                weightedPos{k}(:,j) = probdata2Gauss{k}(thisGauss,ii).*category{k}(thisGauss,j);
            end
            sigmaGauss{k}(:,:,ii) = cov(weightedPos{k}(:,:));
            muChange{k}(ii) = sqrt(sum((parameters.mu{k}(ii,:) - muOLD{k}(ii,:)).^2));
            weightedPos{k} = [];
        end
    end
end
parameters.sigma = sigmaGauss;
end