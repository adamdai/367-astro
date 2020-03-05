function [I_cart] = map_to_cartesian(I_polar, n_h, n_w)
    [size_Th, size_R, C] = size(I_polar);
    y_vals = linspace(-size_R, size_R, n_h);
    x_vals = linspace(-size_R, size_R, n_w);
    [X,Y] = meshgrid(y_vals, x_vals);
    [Th, R] = cart2pol(X, Y);
    Th = wrapTo2Pi(Th);
    Th = size_Th.*normalize_01(Th);
    R = size_R.*normalize_01(R);
    I_cart = zeros(size(I_polar));
    for c = 1:C
        I_cart(:,:,c) = interp2(I_polar(:,:,c), R, Th);
    end
    I_cart(isnan(I_cart)) = 0;
end