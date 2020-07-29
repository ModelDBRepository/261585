function y = circularRandUniform(d)
%
%< circularRandUniform >
%  Returns random value of uniform distribution.
%
%  rand('state',sum(100*clock));
%  rand(2);
%  a = circularRandUniform([2,3])
%
%  Unit is radian.
%
%  Note: Initialize the rand() before use this if you want.
%       Example: 

y = rand(d)*2*pi;




