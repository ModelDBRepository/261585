function dis = circularDiff(x,th)
%
%< circularDiff >
%
%  Returns 'circular difference' dis between data set and specific point th.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  dis = circularDiff(x,pi/4);
%
%  Unit is radian.


th = mod(th, 2*pi);

dis = pi - sum( abs( pi - abs( mod(x-th+pi , 2*pi) - pi )) )/length(x);
