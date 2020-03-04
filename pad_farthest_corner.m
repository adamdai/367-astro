function [I, pad_widths] = pad_farthest_corner(I, rot_center)
% Pads image with 0s so that the farthest corner from the rotation center
% fits within a square matrix, even after an arbitrary rotation.
% Effectively places rotation center in the center of the returned image.
    [H,W] = size(I);  
    diag_dist = ceil(sqrt(max(rot_center(1),H-rot_center(1))^2+max(rot_center(2),W-rot_center(2))^2));
    top_pad = diag_dist-rot_center(1);
    left_pad = diag_dist-rot_center(2);
    bot_pad = diag_dist-(H-rot_center(1));
    right_pad = diag_dist-(W-rot_center(2));
    I = padarray(I, [top_pad,left_pad], 0, 'pre');
    I = padarray(I, [bot_pad,right_pad], 0, 'post');
    pad_widths(1) = left_pad;
    pad_widths(2) = right_pad;
    pad_widths(3) = top_pad;
    pad_widths(4) = bot_pad;
end