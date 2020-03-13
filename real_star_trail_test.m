% ----------------------------------------
% Runs full pipeline on a real star trail image
% 1. center detection
% 2. polar mapping
% 3. deconvolution
% 4. enhancement
% ----------------------------------------

clear, close all
addpath('./deconvolution_funcs');
addpath('./utility');
addpath('./circlefit');

% load the image
img_path = 'stock_photos/star_trail_test.jpg';
I = (im2double(imread(img_path)));
I = I(:,150:450,:);

% Hough center detection
[c,r] = houghfit(I);
rot_center = round(flip(c(1,:)));
[I_blurred, pad_widths] = pad_farthest_corner(I, rot_center);

fprintf('detected center of rotation\n');

% Polar mapping
I_blurred_polar = map_to_polar(I_blurred);

fprintf('mapped to polar\n');

% Deconvolution
blur_th =10;
pix_th = (blur_th/360)*size(I_blurred_polar,1); % Assuming y axis is theta in polar coordinates 
blur_len = floor(pix_th);
psf = zeros(blur_len*2-1, blur_len*2-1);
psf(1:blur_len,blur_len) = 1;

fprintf('beginning deconvolution\n');

max_iters = 20;   
I_deconv_polar = ADMM_TV(I_blurred_polar, psf, 1, 10, max_iters);
I_deconv_cart = map_to_cartesian(I_deconv_polar, size(I_blurred,2), size(I_blurred,1));
I_deconv = unpad_farthest_corner(I_deconv_cart, pad_widths);

% Brightness and contrast enhancement
brightness_scale = 1.55; % 1.55 seems to work well for ADMM, 3 for RL
contrast_scale = 5; % 5 seems to work well for ADMM, 2 for RL
x = (normalize_01(I_deconv)*brightness_scale).^(contrast_scale);


subplot(1,2,1)
imshow(I)
title('Original')
subplot(1,2,2)
imshow(x);
title('Reconstructed image')