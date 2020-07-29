function delta_hat = circularDispersion(x, varargin)
%
%< circularDispersion >
%
%  Returns 'sample circular dispersion' delta_hat.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  tol = 0.0000001;
%  d = circularDispersion(x,tol);
%
%  Default value for optional arguments
%       tol: see circularMean
%
%  Unit is radian.

[tol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


[r,t] = circularMean(x,1,tol);
[r2,t2]=circularMean(x,2,tol);


delta_hat = (1-r2)/(2*r^2);

if r<tol
    delta_hat = NaN;
end