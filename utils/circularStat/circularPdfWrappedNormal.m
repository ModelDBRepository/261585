function y = circularPdfWrappedNormal(th, mu, rho, varargin)
%
%< circularPdfWrappedNormal >
%  Returns pdf value of Wrapped Normal distribution.
%
%       th:  variable
%       mu:  mean direction
%       rho: mean resultant length
%  Optional parameter
%       tol: tolerance level
%  
%  Unit is radian.
%


[tol] = circularArgChk(varargin);
if isnan(tol)
    tol=circularDefaultTol();
end

if rho<0 | rho>1
    warning('rho is out of range. rho is in [0, 1]. Terminaing...')
    y=NaN;
    return;
end

th = mod(th,2*pi);
mu = mod(mu,2*pi);


tol = tol*pi/2;
p = 1;
yic = rho.^(p.^2).*cos(p.*(th-mu));
ytotal = yic;

while sum(sum(abs(yic))) > tol/10
    p = p+1;
    yic = rho.^(p.^2).*cos(p.*(th-mu));
    ytotal = ytotal+yic;
end

% th
% p
% yic
% ytotal
y = (1/2/pi).*(1+2.*ytotal);


