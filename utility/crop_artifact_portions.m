function [x] = crop_artifact_portions(I, pad_widths)
% Used to crop padded image of the portions with blurring artifacts, due to
% padded regions being blurred into regions with data. Used for faithful
% PSNR comparison.
    [H,W,C] = size(I);
    L = pad_widths(1);
    R = pad_widths(2);
    T = pad_widths(3);
    B = pad_widths(4);
    h_dist = ceil(0.5*(H-min(H,W)/sqrt(2)));
    w_dist = ceil(0.5*(W-min(H,W)/sqrt(2)));
    x = I(T+h_dist+1:end-h_dist-B, L+w_dist+1:end-w_dist-R,:);
end