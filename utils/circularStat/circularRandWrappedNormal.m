function y = circularRandWrappedNormal(mu, rho)
%
%< circularRandWrappedNormal >
%  Returns random value of Wrapped Normal distribution.
%  Dimension of the output is the same as the larger one of mu or rho dimensions.
%
%  rand('state',sum(100*clock));  % reset rand() function.
%  rand(2);
%  mu = [1,2,3;4,5,6];
%  rho = 3;
%  a = circularRandWrappedNormal(mu, rho)
%
%  Unit is radian.
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

sigma = sqrt(log(rho).*(-2));

x = normrnd(mu,sigma);
y = mod(x,2*pi);
