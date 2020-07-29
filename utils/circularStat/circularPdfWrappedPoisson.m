function y = circularPdfWrappedPoisson(r, lambda, m, varargin)
%
%< circularPdfWrappedPoisson >
%  Returns pdf value of Wrapped Poisson distribution. This distribution
%  represents the probability of th (steps of rotation) given that average
%  rotation step number is lambda, where one step is 2*pi/m. Therefore, th
%  must be equal to (2*pi/m)*r, where r is integer. In this sense, this
%  function receives r instead of th. If you want to use th, see the
%  example below.
%
%  circularPdfWrappedPoisson(r, lambda, m, varargin)
%       r:   number of circular steps
%       lambda: mean number of steps in a given period (determined by user)
%       m:   number of steps in one circle, i.e., step size is 2*pi/m
%  Optional parameter
%       tol: tolerance level
%       th:  Use this variable if you don't want to use r.
%
%  Example
%       r = 2;
%       lambda = 4;
%       m = 8;
%       y = circularPdfWrappedPoisson(r,lambda,m);
%       tol = circularDefaultTol();
%       y = circularPdfWrappedPoisson(r,lambda,m,tol);
%       th = 2*pi/m*r;
%       y = circularPdfWrappedPoisson(r,lambda,m,tol,th);
%       y = circularPdfWrappedPoisson(NaN,lambda,m,NaN,th);
%
%  Unit is radian.
%


[tol, th] = circularArgChk(varargin);
if isnan(tol)
    tol=circularDefaultTol();
end
if ~isnan(th)
    th = mod(th,2*pi);
    r = floor(th/(2*pi/m))+1;
end
if isnan(r) & isnan(th)
    warning('no input...');
    y = nan;
    return;
end
if isnan(th)
    if mod(r,1)~=0
        warning('r should be integer...');
        y = nan;
        return;
    elseif r>=m | r<0
        warning('r should be an integer in [0,m).');
        y = nan;
        return;
    end
end

tol = tol*exp(lambda)/2;
k = 0;
n = r+k*m;
yic = (lambda.^(n))./(factorial(n));
ytotal = yic;

while sum(sum(abs(yic))) > tol/10
    k = k+1;
    n = r+k*m;
    yic = (lambda.^(n))./(factorial(n));
    ytotal = ytotal+yic;
end

% r
% m
% lambda
% k
% yic
% ytotal
y = ytotal*exp(-lambda);


