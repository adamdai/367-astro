function [x] = normalize_01(x)
    x = (x - min(x, [], 'all'))./(max(x, [], 'all')-min(x, [], 'all'));
end