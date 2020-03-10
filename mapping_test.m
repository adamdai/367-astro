clear, close all
addpath('./deconvolution_funcs');
addpath('./utility');


I = make_circ(15, 200, 300);
[H, W, C] = size(I);

I_polar = map_to_polar_test(I);
I_cart = map_to_cartesian_test(I_polar, H, W);

subplot(1,2,1);
imshow(I);
subplot(1,2,2);
imshow(I_cart);


function [I_polar] = map_to_polar_test(I)
% Assumes center of rotation is at image center
    [H,W,C] = size(I);
    radius_vals = linspace(0, max(H,W)/sqrt(2), ceil(max(H,W)/sqrt(2)));
    angle_vals = linspace(0, 2*pi, 2*W+2*H);
    [R, Th] = meshgrid(radius_vals, angle_vals);
    [X,Y] = pol2cart(Th, R);
    X = X + W/2;
    Y = Y + H/2;
    I_polar = zeros(2*W+2*H, ceil(max(H,W)/sqrt(2)));
    for c = 1:C
        I_polar(:,:,c) = interp2(I(:,:,c), X, Y);
    end
    I_polar(isnan(I_polar)) = 0;
end

function [I_cart] = map_to_cartesian_test(I_polar, H, W)
    x_vals = linspace(-W/2, W/2, W);
    y_vals = linspace(-H/2, H/2, H);
    [X, Y] = meshgrid(x_vals, y_vals);
    [Th, R] = cart2pol(X, Y);
    Th = wrapTo2Pi(Th)*(2*H+2*W)/(2*pi);
    for c = 1:size(I_polar,3)
        I_cart(:,:,c) = interp2(I_polar(:,:,c), R, Th);
    end
    I_cart(isnan(I_cart)) = 0;
end