function [cont_r_mean, cont_th_mean] = circularContMean(fhandle, varargin)
%
%< circularContMean >
%
%  Returns 'mean resultant length R_bar', and 'mean direction Theta_bar'
%  with moment 'p' for continuous distribution function 'fhandle', with
%  integral tolerance level 'tol'.
%
%  That is, it retruns Trigonometirc Moments for continuous distribution
%  function 'fhandle'.
%
%  myDist = @(th) 1/2/pi;
%  p = 2;                   % moment
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  [r_mean, th_mean] = circularMean(myDist,p,tol,quadtol);
%
%  Default values for optional arguments
%       p = 1
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularMean for more information on discrete samples
%

[p,tol,quadtol] = circularArgChk(varargin);
if isnan(p)
    p=1;
end
if isnan(tol)
    tol=circularDefaultTol();
end

if p==0
    warning('p is 0 in circularMean. Terminating...')
    r_mean=NaN;
    th_mean=NaN;
    return;
elseif p<1
    warning('p is less than 1 in circularContMean.') % disp('p is less than 0.')
elseif mod(p,1)~=0
    warning('p is not integer in circularContMean.')
end


cos_fhandle = @(th) cos(p*th).*fhandle(th);
sin_fhandle = @(th) sin(p*th).*fhandle(th);

Cp = circularQuad(cos_fhandle, 0, 2*pi, quadtol);
Sp = circularQuad(sin_fhandle, 0, 2*pi, quadtol);

cont_r_mean = sqrt(Cp^2 + Sp^2);

if cont_r_mean <= tol
    cont_th_mean = NaN;
elseif Sp>=0 & Cp>=0
    cont_th_mean = atan(Sp/Cp);
elseif Cp<0
    cont_th_mean = atan(Sp/Cp)+pi;
elseif Sp<0 & Cp>=0
    cont_th_mean = atan(Sp/Cp)+pi+pi;
end

