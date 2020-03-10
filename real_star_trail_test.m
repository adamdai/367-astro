clear, close all
addpath('./deconvolution_funcs');
addpath('./utility');

img_path = 'stock_photos/star_trail_3.jpg';

%img_path = 'stock_photos/star_trail_test.jpg';
%rot_center = [133, 277];
I = (im2double(imread(img_path)));

bw = imbinarize(rgb2gray(I));
[rows, columns] = find(bw);
[xc,yc,R,a] = circfit(columns,rows);
rot_center = round([yc, xc]);
[I_blurred, pad_widths] = pad_farthest_corner(I, rot_center);

fprintf('detected center of rotation\n');

I_blurred_polar = map_to_polar(I_blurred, size(I_blurred,2), size(I_blurred,1));

fprintf('mapped to polar\n');

blur_th = 10;
pix_th = (blur_th/360)*size(I_blurred_polar,1); % Assuming y axis is theta in polar coordinates 
blur_len = floor(pix_th);
psf = zeros(blur_len*2-1, blur_len*2-1);
psf(1:blur_len,blur_len) = 1;

fprintf('beginning deconvolution\n');

max_iters = 20;   
I_deconv_polar = RL_TV(I_blurred_polar, psf, 0.01, max_iters);
I_deconv_cart = map_to_cartesian(I_deconv_polar, size(I_blurred,2), size(I_blurred,1));
I_deconv = unpad_farthest_corner(I_deconv_cart, pad_widths);

subplot(1,2,1)
imshow(I)
title('Original')
subplot(1,2,2)
imshow(normalize_01(I_deconv));
title('Reconstructed image')