function [a,b,c,d,e,f,g,h,i] = circularArgChk(data)
%
%< circularArgChk >
%  This is a simple helper function for varargin checking.
%  You don't have to pay attention to this function.
%

if length(data)>=1
    a = data{1};
else
    a = NaN;
end

if length(data)>=2
    b = data{2};
else
    b = NaN;
end

if length(data)>=3
    c = data{3};
else
    c = NaN;
end

if length(data)>=4
    d = data{4};
else
    d = NaN;
end

if length(data)>=5
    e = data{5};
else
    e = NaN;
end

if length(data)>=6
    f = data{6};
else
    f = NaN;
end

if length(data)>=7
    g = data{7};
else
    g = NaN;
end

if length(data)>=8
    h = data{8};
else
    h = NaN;
end

if length(data)>=9
    i = data{9};
else
    i = NaN;
end

