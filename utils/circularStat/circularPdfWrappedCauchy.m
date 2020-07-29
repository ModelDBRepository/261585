function y = circularPdfWrappedCauchy(th, mu, rho)
%
%< circularPdfWrappedCauchy >
%  Returns pdf value of Wrapped Cauchy distribution.
%
%  circularPdfWrappedCauchy(th, mu, rho)
%       th:  variable
%       mu:  mean direction
%       rho: mean resultant length
%
%  Unit is radian.
%
%  Note: If rho==0 -> unifrom dist. If rho=1 -> point distribution at mu.
%

if rho<0 | rho>1
    warning('rho is out of range. 0<=rho<=1. Terminaing...')
    y=NaN;
    return;
end

th = mod(th,2*pi);
mu = mod(mu,2*pi);

y = 1/2/pi.*(1-rho.^2)./(1+rho.^2-2.*rho.*cos(th-mu));




