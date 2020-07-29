function s_hat = circularSkewness(x, varargin)
%
%< circularDispersion >
%
%  Returns 'sample circular dispersion' s_hat.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  tol = 0.0000001;
%  s = circularSkewness(x,tol);
%
%  Default value for optional arguments
%       tol: see circularMean
%
%  Unit is radian.

[tol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,t] = circularMean(x,1,tol);
[r2,t2]=circularMean(x,2,tol);

s_hat = (r2*sin(t2-2*t))/((1-r)^1.5);

if (1-r)<tol
    s_hat = NaN;
end
