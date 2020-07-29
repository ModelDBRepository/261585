function th_tilde = circularMedian(x)
%
%< circularDispersion >
%
%  Returns 'sample circular dispersion' s_hat.
%
%  x = [pi/6, pi/3, pi/2];  % data set
%  tol = 0.0000001;
%  s = circularMedian(x,tol);
%
%  Unit is radian.

if mod(length(x),2) == 0  % # of data is even.
    % make a set of dividing data
    pt = sort(mod(x,2*pi));
    ptt = ( pt(1:length(pt)-1) + pt(2:length(pt)) ) /2;
    pta = mod( ( pt(1) + pt(length(pt)) - 2*pi ) /2,  2*pi);
    if pta<=ptt(1)
        points = [pta,ptt];
    else
        points = [ptt,pta];
    end
else
    points = sort(mod(x,2*pi));
end


minth = points(1);
mind = circularDiff(x,minth);
for i=2:length(points)
    if mind > circularDiff(x,points(i))
        minth = points(i);
    end
end

th_tilde = minth;

