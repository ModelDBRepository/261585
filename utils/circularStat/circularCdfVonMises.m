function y = circularCdfVonMises(th, mu, kappa)
%
%< circularCdfVonMises >
%  Returns cdf value of von Mises distribution.
%
%       th:  variable
%       mu:  mean direction
%       kappa: von Mises specific parameter.
%  
%  Unit is radian.
%

if kappa <0
    warning('kappa cannot be negative...')
    y = nan;
    return;
end

if kappa == 0
    y = circularCdfUniform(th);
    return;
end

th = mod(th, 2*pi);
mu = mod(mu, 2*pi);

Ipk = @(p,k) besseli(p,k);
Apk = @(p,k) besseli(p,k)/besseli(0,k);

for i=1:length(th)
    fh = @(x) exp(kappa.*cos(x-mu));
    s(i) = quad(fh,0,th(i));
end

y = s/[2.*pi.*Ipk(0,kappa)];


