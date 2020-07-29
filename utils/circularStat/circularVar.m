function V = circularVariance(x, varargin)
%
%< circularVariance >
%
%  Returns 'sample circular variance' V.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  tol = 0.0000001;
%  V = circularVariance(x,tol);
%
%  Default value for optional arguments
%       tol: see circularMean
%
%  Unit is radian.

[tol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,th] = circularMean(x,1,tol);

V = 1-r;
