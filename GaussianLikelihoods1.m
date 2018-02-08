clc
clear all

w = zeros(2,25);
gradient = zeros(2,25);

x = [-2, -1, 1, 2];
x1 = x(x<0);
x2 = x(x>0);

eta = -0.01;
muStart = 1;
sigmaStart = 2;
w(:,1) = [muStart; sigmaStart];

LL(:,1) = logLikelihood(x1(1),w(:,1));
gradientLL(:,1) = grad_w(x1(1),w(:,1));
absGradient(1) = sqrt(gradientLL(1,1)^2 + gradientLL(2,1)^2);

i = 1;
while absGradient(i) > 0.1
    w(:,i+1) = w(:,i) + eta*gradientLL(:,i);
    LL(:,i+1) = logLikelihood(x1(1),w(:,i+1));
    gradientLL(:,i+1) = grad_w(x1(1),w(:,i+1));
    absGradient(i+1) = sqrt(gradientLL(1,i+1)^2 + gradientLL(2,i+1)^2);
    i = i+1; 
end

function [gradientLL_w] = grad_w(x,w)

   mu = w(1,1);
   sigma = w(2,1);
   gradientLL_w = [mu/sigma^2;...
                  (x-mu)^2/sigma^3];

end

function [Likelihood] = GaussLikelihood(x, w)
    
     mu = w(1,1);
     sigma = w(2,1);
     Likelihood = (1./sqrt(2*pi.*sigma.^2)).*exp(-1.*(x-mu).^2./(2.*sigma.^2));

end

function [LLikelihood] = logLikelihood(x, w)
    
     mu = w(1,1);
     sigma = w(2,1);
     LLikelihood =  -0.5*log(sigma^2) - 0.5*log(2*pi) - 0.5*(1/sigma^2)*(x-mu)^2;
     
end