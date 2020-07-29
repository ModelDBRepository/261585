function dis_cont = circularContDiff(fhandle,mu,varargin)
%
%< circularContDiff >
%
%  Returns 'circular difference' dis_cont between fhandle and specific point mu.
%
%  myDist = @(th) 1/2/pi;
%  mu = pi/3;
%  quadtol = 0.000001;          % integral tolerance level
%  dis_cont = circularContDiff(myDist,mu,quadtol);
%
%  Default values for optional arguments
%       quadtol = the same as the Matlab quad() function
%
%  Unit is radian.
%
%  See also: circularDiff for more information on discrete samples
%

[quadtol] = circularArgChk(varargin);


mu = mod(mu,2*pi);

myfunc = @(th) abs(pi - abs(th-mu)).*fhandle(th);

dis_cont = pi - circularQuad(myfunc,0,2*pi,quadtol);


