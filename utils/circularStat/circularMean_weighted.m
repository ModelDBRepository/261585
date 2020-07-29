function [r,th, rabs]=circularMean_weighted(a, is_radian)
% http://www.springerlink.com/content/wm0301/?p=be7ae4061bf44b04b4e2c289fbd7e6b8&pi=0
% 
% get 0~360 and magnitude like
%  a=[ 250 2; 219 3; 40 6]
% returns mean r and th.
% 

if ~exist('is_radian','var') || isempty(is_radian)
    is_radian = 0;
end

n=size(a,1);
x=0;y=0;z=0;f=0;t=0;r=0;
for i=1 : n
    if is_radian
        [xi,yi]=pol2cart(a(i,1),a(i,2));
    else
        [xi,yi]=pol2cart(a(i,1)*pi/180,a(i,2));
    end
    x=x+xi; y=y+yi;
end
[f,r]=cart2pol(x,y); 
f=f*180/pi;

%r=r/n;
rabs = r;
r=r/sum(abs(a(:,2)));

th=f;

if th>360
    th = th-360;
elseif th<0
    th = th+360;
end


if is_radian
    th = th/180*pi;
end

