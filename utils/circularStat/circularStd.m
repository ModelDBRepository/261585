function v = circularStd(x, varargin)
%
%< circularStd >
%
%  Returns 'circular standard deviation' v.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  tol = 0.0000001;
%  v = circularStd(x,tol);
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

v = sqrt(-2*log(r));

if r < tol
    v = NaN;  % in fact, it should be Inf.
end

