function smd = circularMeanDeviation(x)
%
%< circularMeanDeviation >
%
%  Returns 'sample circular mean deviation' smd (sample mean deviation).
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  tol = 0.0000001;
%  smd = circularMeanDeviation(x,tol);
%
%  Unit is radian.
%

smd = circularDiff(x, circularMedian(x));
