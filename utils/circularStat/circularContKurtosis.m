function K = circularContKurtosis(fhandle, varargin)
%
%< circularContKurtosis >
%
%  Returns 'circular kurtosis' K.
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  K = circularContKurtosis(myDist,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularKurtosis for more information on discrete samples
%

[tol,quadtol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,t] = circularContMean(fhandle,1,tol,quadtol);
[r2,t2]=circularContMean(fhandle,2,tol,quadtol);

K = (r2*cos(t2)-r^4)/((1-r)^2);

if (1-r)<tol
    K = NaN;
end
