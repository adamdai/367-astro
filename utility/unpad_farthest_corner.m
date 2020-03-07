function [I] = unpad_farthest_corner(I, pad_widths)
% Inverse operation for pad_farthest_corner (crops image)
    L = pad_widths(1);
    R = pad_widths(2);
    T = pad_widths(3);
    B = pad_widths(4);
    I = I(T+1:end-B,L+1:end-R,:);
end