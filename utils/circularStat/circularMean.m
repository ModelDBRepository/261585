function [r_mean, th_mean] = circularMean(data, varargin)
%
%< circularMean >
%
%  Returns 'mean resultant length R_bar', and 'mean direction Theta_bar'
%  with moment 'p' and tolerance level 'tol'.
%
%  That is, it retruns Trigonometirc Moments.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  p = 2;                   % moment
%  tol = 0.000001;          % tolerance level
%  [r_mean, th_mean] = circularMean(x,p,tol);
%
%  Default values for optional arguments
%       p = 1
%       tol = 0.000001
%
%  Unit is radian.
%
%  Note: If the measuring bin(h) is large (larger than pi/6 (30degree) for
%  r_mean, larger than pi/12 (15 degree) for r_mean2 (r_mean of moment 2)
%     -->
%  then, USE A(h)*r_mean and A(2h)*r_mean2 instead of r_mean and r_mean2
%  (see page 35 of Fisher). Where A(h) = h/(2*sin(h/2))

[p,tol,quadtol] = circularArgChk(varargin);
if isnan(p)
    p=1;
end
if isnan(tol)
    tol=circularDefaultTol();
end

r_mean = nan;
th_mean = nan;

if p==0
    warning('p is 0 in circularMean. Terminating...')
    return;
elseif p<1
    warning('p is less than 1 in circularMean.') % disp('p is less than 0.')
elseif mod(p,1)~=0
    warning('p is not integer in circularMean.')
end

n = length(data);
Cp = sum(cos(p*data))/n;
Sp = sum(sin(p*data))/n;


r_mean = sqrt(Cp^2 + Sp^2);

if r_mean <= tol
    th_mean = NaN;
elseif Sp>=0 && Cp>=0
    th_mean = atan(Sp/Cp);
elseif Cp<0
    th_mean = atan(Sp/Cp)+pi;
elseif Sp<0 && Cp>=0
    th_mean = atan(Sp/Cp)+pi+pi;
end
