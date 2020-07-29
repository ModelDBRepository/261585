function y = circularPdfCardioid(th, mu, rho)
%
%< circularPdfCardioid >
%  Returns pdf value of Cardioid distribution.
%
%  circularPdfCardioid(th, mu, rho)
%       th:  variable
%       mu:  mean direction
%       rho: mean resultant length
%
%  Unit is radian.
%
%  Sometimes called, "Cosine distribution"

if rho<0 | rho>0.5
    warning('rho is out of range. 0<=rho<=0.5. Terminaing...')
    y=NaN;
    return;
end

th = mod(th,2*pi);
mu = mod(mu,2*pi);

y = 1/2/pi*(1+2*rho*cos(th-mu));




