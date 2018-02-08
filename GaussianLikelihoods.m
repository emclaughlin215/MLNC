clear all
clc

x = [-2, -1, 1, 2];
x1 = x(x<0);
x2 = x(x>0);

mu = -5:0.2:5;
sigma = 0.1:0.1:5;
sigma1 = 0.6;

for j = 1:length(x)
    for i = 1:length(mu)
        for ii = 1:length(sigma)
            w = [mu(i); sigma(ii)];
            L(i,ii,j) = GaussLikelihood(x(j),w);
        end
    end
end

for j = 1:length(x1)
    for i = 1:length(mu)
        w = [mu(i); sigma1];
        L1(i,j) = GaussLikelihood(x1(j),w);
    end
end

for j = 1:length(x2)
    for i = 1:length(mu)
        w = [mu(i); sigma1];
        L2(i,j) = GaussLikelihood(x2(j),w);
    end
end

Ltotal = L(:,:,1) .* L(:,:,2) .* L(:,:,3) .* L(:,:,4);
L1total = L1(:,1) .* L1(:,2);
L2total = L2(:,1) .* L2(:,2);

for j = 1:length(x)
    for i = 1:length(mu)
        for ii = 1:length(sigma)
            w = [mu(i); sigma(ii)];
            LL(i, ii, j) = logLikelihood(x(j),w);
        end
    end
end

LLtotal =  LL(:,:,1) + LL(:,:,2) + LL(:,:,3) + LL(:,:,4);

figure(1)
subplot(2,2,1)
surf(sigma, mu, L(:,:,1))
xlabel('sigma')
ylabel('mu')
title('X1')
figure(1)
subplot(2,2,2)
surf(sigma, mu, L(:,:,2))
xlabel('sigma')
ylabel('mu')
title('X2')
figure(1)
subplot(2,2,3)
surf(sigma, mu, L(:,:,3))
xlabel('sigma')
ylabel('mu')
title('X3')
figure(1)
subplot(2,2,4)
surf(sigma, mu, L(:,:,4))
xlabel('sigma')
ylabel('mu')
title('X4')

figure(2)
surf(sigma, mu, Ltotal(:,:,:))
xlabel('sigma')
ylabel('mu')
title('Total')

figure(4)
surf(mu, mu, L1total(:,:,:))
xlabel('sigma')
ylabel('mu')
title('Total')

figure(5)
surf(mu, mu, L2total(:,:,:))
xlabel('sigma')
ylabel('mu')
title('Total')

figure(3)
surf(sigma, mu, LLtotal(:,:,:))
xlabel('sigma')
ylabel('mu')
title('Total')

function [Likelihood] = GaussLikelihood(x, w)
    
     mu = w(1,1);
     sigma = w(2,1);
     Likelihood = (1./sqrt(2*pi.*sigma.^2)).*exp(-1.*(x-mu).^2./(2.*sigma.^2));

end

function [LLikelihood] = logLikelihood(x, w)
    
     mu = w(1,1);
     sigma = w(2,1);
     LLikelihood =  -0.5*log(1/sigma) - 0.5*log(2*pi) - 0.5*(1/sigma^2)*(x-mu)^2;
     
end




