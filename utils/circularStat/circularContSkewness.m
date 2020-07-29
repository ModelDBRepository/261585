function s = circularContSkewness(fhandle, varargin)
%
%< circularContSkewness >
%
%  Returns 'circular skewness' s.
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  s = circularContSkewness(myDist,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularSkewness for more information on discrete samples
%

[tol,quadtol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,t] = circularContMean(fhandle,1,tol,quadtol);
[r2,t2]=circularContMean(fhandle,2,tol,quadtol);

s = r2*sin(t2)/((1-r)^1.5);

if (1-r)<tol
    s = NaN;
end
