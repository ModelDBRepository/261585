function y = circularCdfCardioid(th, mu, rho)
%
%< circularCdfCardioid >
%  Returns cumulative distribution function value of Cardioid distribution.
%
%  circularCdfCardioid(th, mu, rho)
%       th:  variable
%       mu:  mean direction
%       rho: mean resultant length
%
%  Unit is radian.
%
%  Sometimes called, "Cosine distribution"
%

if rho<0 | rho>0.5
    warning('rho is out of range. 0<=rho<=0.5. Terminaing...')
    y=NaN;
    return;
end

th = mod(th,2*pi);
mu = mod(mu,2*pi);


y = (rho/pi)*sin(th-mu)+th/2/pi;


