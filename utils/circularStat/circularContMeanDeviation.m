function md = circularContMeanDeviation(fhandle, varargin)
%
%< circularContMeanDeviation >
%
%  Returns 'circular mean deviation' md (mean deviation).
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  md = circularContMeanDeviation(myDist,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularMeanDeviation for more information on discrete samples
%

if length(varargin)>=1
    tol = varargin{1};
else
    tol = circularDefaultTol();
end

if length(varargin)>=2
    quadtol = varargin{2};
else
    quadtol = NaN;
end

mu_tilde = circularContMedian(fhandle, tol, quadtol);
md = circularContDiff(fhandle, mu_tilde, quadtol);
