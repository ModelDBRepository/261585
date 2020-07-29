function y = circularRandWrappedCauchy(mu, rho)
%
%< circularRandWrappedCauchy >
%  Returns random value of Wrapped Cauchy distribution.
%
%  rand('state',sum(100*clock));  % reset rand() function.
%  rand(2);
%  a = circularRandWrappedCauchy(mu, rho)
%
%  Dimension is determined by mu or rho.
%
%  Unit is radian.
%
%  Note: If rho==0 -> unifrom dist. If rho=1 -> point distribution at mu.
%

if sum(sum(rho<0)) | sum(sum(rho>1))
    warning('rho is out of range. 0<=rho<=1. Terminaing...')
    y=NaN;
    return;
end

if sum(sum(size(mu)~= size(rho)))>0
    if length(mu)>1 & length(rho)>1
        warning('dimensions of mu and rho are not matching...');
        return;
    end
end

if length(mu)>length(rho)
    U = rand(size(mu));
else
    U = rand(size(rho));
end

V = cos(2.*pi.*U);
c = 2.*rho./(1+rho.^2);
y = mod(acos((V+c)./(1+c.*V))+mu, 2*pi);


