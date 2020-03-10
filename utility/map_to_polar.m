function [I_polar] = map_to_polar(I, n_r, n_th)
% Assumes center of rotation is at image center
    [H,W,C] = size(I);
    radius_vals = linspace(0, H/sqrt(2), n_r);
    angle_vals = linspace(0, 2*pi, n_th);
    [R, Th] = meshgrid(radius_vals, angle_vals);
    [X,Y] = pol2cart(Th, R);
    X = X + W/2;
    Y = Y + H/2;
    I_polar = zeros(size(I));
    for c = 1:C
        I_polar(:,:,c) = interp2(I(:,:,c), X, Y);
    end
    I_polar(isnan(I_polar)) = 0;
end