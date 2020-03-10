function [I_cart] = map_to_cartesian(I_polar, H, W)
    x_vals = linspace(-W/2, W/2, W);
    y_vals = linspace(-H/2, H/2, H);
    [X, Y] = meshgrid(x_vals, y_vals);
    [Th, R] = cart2pol(X, Y);
    Th = wrapTo2Pi(Th)*(2*H+2*W)/(2*pi); % assuming Th sampled (2*H+2*W) times out of 2pi range
    for c = 1:size(I_polar,3)
        I_cart(:,:,c) = interp2(I_polar(:,:,c), R, Th);
    end
    I_cart(isnan(I_cart)) = 0;
end