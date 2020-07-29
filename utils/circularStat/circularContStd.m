function sgm = circularContStd(fhandle, varargin)
%
%< circularContStd >
%
%  Returns 'circular standard deviation' sgm (sigma).
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  sgm = circularContStd(myDist,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularStd for more information on discrete samples
%

[tol,quadtol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,t] = circularContMean(fhandle,1,tol,quadtol);

sgm = sqrt(-2*log(r));

if r < tol
    sgm = NaN; % in fact, it should be Inf
end

