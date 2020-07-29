function y = circularPdfVonMises(th, mu, kappa, unit)
%
%< circularPdfVonMises >
%  Returns pdf value of von Mises distribution.
%
%       th:  variable
%       mu:  mean direction
%       kappa: von Mises specific parameter.
%       unit: determine the unit. default is radian
%           'radian' or
%           'degree'
%  
%  Unit is radian.
%

if ~exist('unit','var')  |  ( exist('unit','var') & strcmp(unit,'radian') )
    a=1; % Just OK.
elseif exist('unit','var') & strcmp(unit,'degree')
    th = th/180*pi;
    mu = mu/180*pi;
else
    error('circularPdfVonMises: unit is wrong.\n');
end

if kappa <0
    warning('kappa cannot be negative...')
    y = nan;
    return;
end

if kappa ==0
    y = circularPdfUniform(th);
    return;
end
    


th = mod(th, 2*pi);
mu = mod(mu, 2*pi);

Ipk = @(p,k) besseli(p,k);
Apk = @(p,k) besseli(p,k)/besseli(0,k);


y = exp(kappa.*cos(th-mu))./[2*pi*Ipk(0,kappa)];





