clear, close all
img_path = 'stock_photos/star_trail_test.jpg';
I = rgb2gray(im2double(imread(img_path)));
[H, W] = size(I);
rot_center = [130, 285];
[I_blurred, pad_widths] = pad_farthest_corner(I, rot_center);


I_blurred_polar = map_to_polar(I_blurred, size(I_blurred,2), size(I_blurred,1));

blur_th = 10;
pix_th = (blur_th/360)*size(I_blurred_polar,1); % Assuming y axis is theta in polar coordinates 
blur_len = floor(pix_th);
psf = zeros(blur_len*2-1, blur_len*2-1);
psf(1:blur_len,blur_len) = 1;

max_iters = 100;   
I_deconv_polar = RL_deconv(I_blurred_polar, psf, max_iters);
I_deconv_cart = map_to_cartesian(I_deconv_polar, size(I_blurred,2), size(I_blurred,1));
I_deconv = unpad_farthest_corner(I_deconv_cart, pad_widths);
