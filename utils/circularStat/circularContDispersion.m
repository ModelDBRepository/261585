function delta = circularContDispersion(fhandle, varargin)
%
%< circularContDispersion >
%
%  Returns 'circular dispersion' delta.
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  delta = circularContDispersion(myDist,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularDispersion for more information on discrete samples
%

[tol,quadtol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,t] = circularContMean(fhandle,1,tol,quadtol);
[r2,t2]=circularContMean(fhandle,2,tol,quadtol);

delta = (1-r2)/(2*r^2);

if r<tol
    delta = NaN;
end
