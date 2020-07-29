function v = circularContVar(fhandle, varargin)
%
%< circularContVar >
%
%  Returns 'circular variance' v.
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  v = circularContVar(myDist,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularVar for more information on discrete samples
%

[tol,quadtol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,t] = circularContMean(fhandle,1,tol,quadtol);

v = 1-r;
