function y = circularRandVonMises(mu, kappa, varargin)
%
%< circularRandVonMises >
%  Returns random value of von Mises distribution.
%
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

[di] = circularArgChk(varargin);
if isnan(di)
    di=1;
end

if length(di)==1
    di(1,2)=1
end

if kappa == 0
    y = circularRandUniform(di);
    return;
end

a = 1+sqrt(1+4*kappa^2);
b = (a-sqrt(2*a))/(2*kappa);
r = (1+b^2)/(2*b);

for i=1:di(1,1)
    for j=1:di(1,2)

        while(1)
            u1 = rand(1);
            u2 = rand(1);
            u3 = rand(1);

            z = cos(pi*u1);
            f = (1+r*z)/(r+z);
            c = kappa*(r-f);

            kkk = c*(2-c) - u2;
            if kkk > 0 | (kkk <= 0 & log(c/u2)+1-c >= 0)
                yy = mod(sign(u3-0.5)*acos(f)+mu, 2*pi);
                break;
            end
        end

        y(i,j)=yy;
    end
end
