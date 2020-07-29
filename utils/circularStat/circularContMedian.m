function mu_tilde = circularContMedian(fhandle, varargin)
%
%< circularContMedian >
%
%  Returns 'circular median' mu_tilde.
%
%  myDist = @(th) 1/2/pi;
%  tol = circularDefaultTol()   % tolerance level
%  quadtol = 0.000001;          % integral tolerance level
%  mu = circularContMedian(myDist,tol,quadtol);
%
%  Default values for optional arguments
%       tol = see circularDefaultTol()
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularKurtosis for more information on discrete samples
%
%  Note: If fhandle is not a unimodal pdf, uniqueness of the solution is not
%  guaranteed. Therefore, the solution represents only one of possible
%  solution in that case.

[tol,quadtol] = circularArgChk(varargin);
if isnan(tol)
    tol = circularDefaultTol();
end


rand('state',sum(100*clock));
rand(2);

th_current = rand(1)*2*pi;
th_left = mod(th_current+pi, 2*pi);
th_right = mod(th_current+pi, 2*pi);
if th_left > th_current
    th_left = th_left - 2*pi;
end
if th_right < th_current
    th_right = th_right + 2*pi;
end

part1 = circularQuad(fhandle,th_current-pi, th_current, quadtol); % left
part2 = circularQuad(fhandle,th_current, th_current+pi, quadtol); % right

while abs(part1-part2) >= tol
    if part1 > part2
        th_tmp = th_current;
        th_current = (th_current+th_left)/2;
        th_right = th_tmp;
    elseif part1 < part2
        th_tmp = th_current;
        th_current = (th_current+th_right)/2;
        th_left = th_tmp;
    end
    part1 = circularQuad(fhandle,th_current-pi, th_current, quadtol); % left
    part2 = circularQuad(fhandle,th_current, th_current+pi, quadtol); % right
end

if fhandle(th_current)>fhandle(th_current+pi)
    mu_tilde = mod(th_current, 2*pi);
else
    mu_tilde = mod(th_current+pi, 2*pi);
end


