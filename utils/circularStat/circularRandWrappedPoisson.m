function [r, y] = circularRandWrappedPoisson(lambda,m)
%
%< circularRandWrappedPoisson >
%  Returns random value of Wrapped Normal distribution.
%  Dimension of the output is the same as the larger one of lambda or m dimensions.
%
%  rand('state',sum(100*clock));  % reset rand() function.
%  rand(2);
%  lambda = 2;
%  m = [4,6];
%  a = circularRandWrappedPoisson(lambda,m);
%
%  Unit is radian.
%

if m<1 | mod(m,1)~=0
    warning('m cannot be negative, and must be integer. Terminaing...')
    y=NaN;
    return;
end

if lambda<=0
    warning('lambda must be positive number...');
    y = NaN;
    return;
end

if sum(sum(size(lambda) ~= size(m))) > 0
    if length(lambda)>1 & length(m)>1
        warning('dimension mismatch...');
        y=nan;
        return;
    end
end

if length(lambda)>1
    x = poissrnd(lambda);
else
    x = poissrnd(lambda,size(m));
end

r = mod(x,m);
y = r.*2.*pi./m;
