function k_hat = circularKurtosis(x, varargin)
%
%< circularDispersion >
%
%  Returns 'sample circular Kurtosis' k_hat.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  tol = 0.0000001;
%  k = circularKurtosis(x,tol);
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

k_hat = (r2*cos(t2-2*t)-r^4)/((1-r)^2);

if (1-r)<tol
    k_hat = NaN;
end
