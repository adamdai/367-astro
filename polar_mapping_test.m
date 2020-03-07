clear
addpath('./deconvolution_funcs');
addpath('./utility');

% Get sample image
img_path = 'stock_photos/stock_02.jpg';
I = im2double(imread(img_path));
%I = I(1000:3000, 2000:4000, :);
I = I(1:100, 1:100, :);

% Generate rotationally blurred image
rot_center = [ceil(size(I,1)/2),ceil(size(I,2)/2)];
[I_pad, pad_widths] = pad_farthest_corner(I, rot_center);
blur_th = 15;
I_blurred = rotate_blur_image(I_pad, blur_th);
I_blurred_polar = map_to_polar(I_blurred, size(I_blurred,2), size(I_blurred,1));

% Generate blur PSF
pix_th = (blur_th/360)*size(I_blurred_polar,1); % Assuming y axis is theta in polar coordinates 
blur_len = floor(pix_th);
psf = zeros(blur_len*2-1, blur_len*2-1);
psf(1:blur_len,blur_len) = 1;

% Deconvolution 
%I_deconv_polar = wiener(I_blurred_polar, psf, 0.001);
%I_deconv_polar = ADMM_sparse(I_blurred_polar, psf, 10, 10, 50);
%I_deconv_polar = ADMM_TV(I_blurred_polar, psf, 1, 10, 50);
%I_deconv_polar = RL(I_blurred_polar, psf, 25);
I_deconv_polar = RL_TV(I_blurred_polar, psf, 0.01, 100);
I_deconv_cart = map_to_cartesian(I_deconv_polar, size(I_blurred,2), size(I_blurred,1));
I_deconv = unpad_farthest_corner(I_deconv_cart, pad_widths);


subplot(1,2,1)
imshow(I)
title('Original')
subplot(1,2,2)
imshow(normalize_01(I_deconv));
title('Reconstructed image')

fprintf('PSNR = %f \n',psnr(I,normalize_01(I_deconv))); 
% subplot(1,6,3)
% imshow(normalize_01(I_blurred_polar))
% title('Polar transform of blurred')
% subplot(1,6,4)
% imshow(I_deconv_polar)
% title('RL deconv polar transform')
% subplot(1,6,5)
% imshow(I_deconv_cart)
% title('RL deconv cartesian')
% subplot(1,6,6)


