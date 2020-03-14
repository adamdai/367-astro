function [x] = normalize_01(x)
% Normalizes image in range 0-1
    x = (x - min(x, [], 'all'))./(max(x, [], 'all')-min(x, [], 'all'));
end