function class = ClassifyX(input, parameters)
%% Gaussian Mixed Model Classification

x = 2;
% For all test points, calculate the likelihood it belongs to each
% Gaussian
for i = 1:size(input,1)
    fr k = 1:2
        for ii = 1:length(parameters.mu{k}(:,1))
            prob2Gauss(k,ii,i) = 1./((2*pi)^(3/2)*det(parameters.sigma{k}(:,:,ii))^(1/2)) * ...
                    exp(-0.5*(input(i,:) - parameters.mu{k}(ii,:))...
                    *inv(parameters.sigma{k}(:,:,ii))*(input(i,:) - parameters.mu{k}(ii,:))');
        end
    end
endo

%normalise the probability
for ii = 1:x
    for i = 1:size(input,1)
        normProb2Gauss(1:2,ii,i) = [prob2Gauss(1,ii,i)./(x*(prob2Gauss(1,ii,i)+prob2Gauss(2,ii,i))),...
                                    prob2Gauss(2,ii,i)./(x*(prob2Gauss(1,ii,i)+prob2Gauss(2,ii,i)))];
    end
end                       
                        
% For each test point calculate the set of Gaussians (i.e. the class) it most likely belongs to and
% designate the label of the Gaussian to it.
for i = 1size(input,1)
    [~, Gaussindex] = max(sum(prob2Gauss(:,:,i),2));
    class(i,1) = Gaussindex(1,1);
end

%plot the test data with relevant colour representing the probability they
%belong to each class
% figure
% h = plot3(1,1,1,'ro');
% hold on
% h1 = plot3(1,1,1,'bo');
% set(h,'Visible','off')
% set(h1,'Visible','off')
% xlabel('x')
% ylabel('y')
% zlabel('z')
% for i = 1:size(input,1)
%     colour = sum(normProb2Gauss(1:2,1:end,i),2);
%     redcolour = colour(1,1);
%     bluecolour = colour(2,1);
%     plot3(input(i,1),input(i,2),input(i,3), 'o', 'MarkerEdgeColor', [redcolour 0.05 bluecolour])
%     grid on
% end
% hold off
% title([parameters.class1, ' and ', parameters.class2])
% lgd = legend([h, h1],{[parameters.class1], [parameters.class2]},'TextColor','k','location', 'best');

end


