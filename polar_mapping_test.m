clear, close all

% I = make_circ([300,500], 10, [50,50]);
img_path = 'stock_photos/stock_01.jpg';
I = rgb2gray(im2double(imread(img_path)));
I = I(1:500, 1:800);
I = pad_rotate_img(I);
I(I>0.5) = 1;
I(I<=0.5) = 0;

blurred_I = I;
for th = linspace(0,25,100)
    blurred_I = blurred_I + imrotate(I, th, 'nearest', 'crop');
end
blurred_I = normalize(blurred_I);

rot_center = [ceil(size(I,1)/2),ceil(size(I,2)/2)];

I_pad = pad_farthest_corner(I, rot_center);
I_polar = map_to_polar(I_pad, size(I_pad,2), size(I_pad,1));
I_blur_pad = pad_farthest_corner(blurred_I, rot_center);
I_blur_polar = map_to_polar(I_blur_pad, size(I_blur_pad,2), size(I_blur_pad,1));
I_blur_cart = map_to_cartesian(I_blur_polar, size(I_blur_pad,2), size(I_blur_pad,1));

c_size = 50;
lambda = 0.01;
rho = 10;
iterations = 50;
I_deblur = ADMM_deblur_fcn(I_blur_polar, c_size, lambda, rho, iterations);
I_deblur_cart = map_to_cartesian(I_deblur, size(I_blur_pad,2), size(I_blur_pad,1));

figure(1)
subplot(3,2,1)
imshow(I)
title('Original')
subplot(3,2,2)
imshow(I_polar)
title('Original polar transform')
subplot(3,2,3)
imshow(I_blur_pad)
title('Radially blurred')
subplot(3,2,4)
imshow(I_blur_polar)
title('Blurred polar transform')
subplot(3,2,5)
imshow(I_deblur_cart)
title('ADMM deblurred cartesian transform')
subplot(3,2,6)
imshow(I_deblur)
title('ADMM deblurred polar transform')



function [I_cart] = map_to_cartesian(I_polar, n_h, n_w)
    [size_Th, size_R] = size(I_polar);
    y_vals = linspace(-size_R, size_R, n_h);
    x_vals = linspace(-size_R, size_R, n_w);
    [X,Y] = meshgrid(y_vals, x_vals);
    [Th, R] = cart2pol(X, Y);
    Th = wrapTo2Pi(Th);
    Th = size_Th.*normalize(Th);
    R = size_R.*normalize(R);
    min(R,[],'all');
    max(R,[],'all');
    I_cart = interp2(I_polar, R, Th);
    I_cart(isnan(I_cart)) = 0;
    %I_cart = normalize(I_cart);
end

function [I_polar] = map_to_polar(I, n_r, n_th)
    [H,W] = size(I);
    radius_vals = linspace(0, H/sqrt(2), n_r);
    angle_vals = linspace(0, 2*pi, n_th);
    [R, Th] = meshgrid(radius_vals, angle_vals);
    [X,Y] = pol2cart(Th, R);
    X = X + W/2;
    Y = Y + H/2;
    I_polar = interp2(I, X, Y);
    I_polar(isnan(I_polar)) = 0;
    %I_polar = normalize(I_polar);
end

function [I] = make_circ(img_size, circ_size, circ_center)
    I = zeros(img_size(1),img_size(2));
    for i = 1:size(I,1)
        for j = 1:size(I,2)
            if sqrt((i-circ_center(1))^2 + (j-circ_center(2))^2) < circ_size
                I(i,j) = 1;
            end
        end
    end
end

function [I] = pad_farthest_corner(I, rot_center)
    [H,W] = size(I);  
    diag_dist = ceil(sqrt(max(rot_center(1),H-rot_center(1))^2+max(rot_center(2),W-rot_center(2))^2));
    top_pad = diag_dist-rot_center(1);
    left_pad = diag_dist-rot_center(2);
    bot_pad = diag_dist-(H-rot_center(1));
    right_pad = diag_dist-(W-rot_center(2));
    I = padarray(I, [top_pad,left_pad], 0, 'pre');
    I = padarray(I, [bot_pad,right_pad], 0, 'post');
end

function [x] = normalize(x)
    x = (x - min(x, [], 'all'))./max(x, [], 'all');
end

function [x] = pad_rotate_img(x)
    [H,W] = size(x);
    diag_dist = ceil(norm(size(x)));
    x = padarray(x, [ceil((diag_dist-H)/2), ceil((diag_dist-H)/2)]);
end