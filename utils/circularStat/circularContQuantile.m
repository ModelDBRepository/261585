function [mup, mu0] = circularContQuantile(fhandle, p, varargin)
%
%< circularContQuantile >
%
%  Returns 'circular quantile' mu0 (where quantile is zero), and
%  mup (mu-p), the place where integral from opposite side of
%  median to the place is p (0<p<1).
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol();  % tolerance level
%  p = 0.37;
%  quadtol = 0.000001;          % integral tolerance level
%  [mup, mu0] = circularContQuantile(myDist,p,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%

[tol,quadtol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end

if p<0 | p>1
    warning('p is out of range in circularContQuantile. Terminating...');
    mup = NaN;
    return;
end

mu0 = mod(circularContMedian(fhandle,tol,quadtol)+pi, 2*pi);
n = ceil(1/p);

step = 2*pi/n;
th_current = mu0;
part = -1;

while part < p
    th_current = th_current+step;
    part = circularQuad(fhandle,mu0,th_current,quadtol);
end
th_left = mu0;
th_right = th_current;
th_current = th_current - step;
part = circularQuad(fhandle,mu0,th_current,quadtol);
%     disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%     th_left
%     th_current
%     th_right

while abs(part-p) >= tol
    if part > p
        th_tmp = th_current;
        th_current = (th_current+th_left)/2;
        th_right = th_tmp;
    elseif part < p
        th_tmp = th_current;
        th_current = (th_current+th_right)/2;
        th_left = th_tmp;
    end
%     disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%');
%     th_left
%     th_current
%     th_right
    part = circularQuad(fhandle,mu0, th_current, quadtol);
end

mup = mod(th_current, 2*pi);


