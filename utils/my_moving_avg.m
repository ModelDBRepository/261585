function r = my_moving_avg(a, span, selection)
% takes care of nan
% 'span' should be odd number

if mod(span,2)==0
%    error('use odd number for span');
end

if span>numel(a)
    error('span cannot be larger than the number of elements');
end


ns = floor(span/2);

if ~exist('selection', 'var') || isempty(selection)
    idx = numel(a):-1:1;
else
    ttttt = sort(selection(:),'descend');
    idx = ttttt(:)';
end


if span/2 > ns % odd number
    for ri = idx
        if isnan(a(ri))
            r(ri) = nan;
        else
            r(ri) = nanmean(a(  max(1,(ri-ns)):min(end,(ri+ns))  ));
        end
    end
else % even number
    for ri = idx
        if isnan(a(ri))
            r(ri) = nan;
        else
            b = a(  max(1,(ri-ns)):min(end,(ri+ns))  );
            if numel(b)==span+1
                b(1) = nanmean([b(1), b(end)]);
                b(end) = [];
            end
            r(ri) = nanmean(b);
        end
    end
end

if exist('selection', 'var') && ~isempty(selection)
    r = r(selection);
end

return;
















ns = floor(span/2);
for ri = (numel(a)-ns):-1:(ns+1)
    
    if isnan(a(ri))
        r(ri-ns) = nan;
    else
        r(ri-ns) = nanmean(a((ri-ns):(ri+ns)));
    end
    
    
end







