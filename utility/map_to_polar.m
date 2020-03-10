function [I_polar] = map_to_polar(I)
% Assumes center of rotation is at image center
    [H,W,C] = size(I);
    radius_vals = linspace(0, max(H,W)/sqrt(2), ceil(max(H,W)/sqrt(2)));
    angle_vals = linspace(0, 2*pi, 2*H+2*W); % samples a theta for each pixel on perimeter
    [R, Th] = meshgrid(radius_vals, angle_vals);
    [X,Y] = pol2cart(Th, R);
    X = X + W/2;
    Y = Y + H/2;
    I_polar = zeros(2*H+2*W, ceil(max(H,W)/sqrt(2)));
    for c = 1:C
        I_polar(:,:,c) = interp2(I(:,:,c), X, Y);
    end
    I_polar(isnan(I_polar)) = 0;
end