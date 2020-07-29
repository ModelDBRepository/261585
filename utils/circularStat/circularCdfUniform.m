function y = circularCdfUniform(th)
%
%< circularCdfUniform >
%  Returns cumulative distribution function value of uniform distribution.
%
%  circularCdfUniform(th)
%
%  Unit is radian.
%

th = mod(th,2*pi);
y = th/2/pi;





