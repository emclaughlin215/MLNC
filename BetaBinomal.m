%CHOOSE ALPHA AND BETA PRIOR PARAMETERS FOR BETA PRIOR 
%(WHICH MODELS YOUR BELIEF OF THE VALUE OF qTrue
alpha = 1 %DEFAULT VALUE 15
beta = 1000 %DEFAULT VALUE 15

%CHOOSE NUMBER OF HEADS OBSERVED
h = 1 %DEFAULT VALUE 7
%CHOOSE NUMBER OF TAILS OBSERVED
t = 0 % DEFAULT VALUE 3

%plot resolution
epsilon = 0.01;
Q = [epsilon:epsilon:(1-epsilon)];
pQPrior = betapdf(Q,alpha,beta);


% Plot the prior distribution
subplot(3,1,1)
plot(Q,pQPrior,'r-')
title(['Beta Prior with \alpha=' num2str(alpha) ' & \beta=' num2str(beta)])
xlabel('q')
ylabel(['P(q| \alpha=' num2str(alpha) ' \beta=' num2str(beta) ')'])

subplot(3,1,2)
% Plot the likelihood distribution p(x| q, h+t)
pQLikelihood = binopdf(h,h+t,Q)
plot(Q,pQLikelihood,'-')
title(['Binomial likelihood for ' num2str(h) ' heads & ' num2str(t) ' tails'])
xlabel('q')
ylabel(['P(' num2str(h) ' heads &' num2str(t) ' tails)'])


%% Plot the posterior distribution
subplot(3,1,3)
pQPosterior = pQPrior.*pQLikelihood;
pQPosterior = pQPosterior./sum(pQPosterior)
plot(Q,pQPosterior,'k-')
title('Posterior probability for q')
xlabel('q')
ylabel(['P(q |' num2str(h) ' head &' num2str(t) ' tail)'])

