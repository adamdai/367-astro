clear, close all
addpath('./deconvolution_funcs');
addpath('./utility');

imgpath = './stock_photos/stock_02.jpg';
I = im2double(imread(imgpath));
I = I(1500:2000, 3000:3500, :);
[H, W, C] = size(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%
blur_th = 15;
rot_center = [ceil(H/2),ceil(W/2)];
deconv_method = 'ADMM';
prior = 'sparse';
deconv_iters = 25;
lambda = 1;
rho = 10;
sigma_noise_wiener = 0.5;
brightness_scale = 1.5;
sigma_spatial_bilateral = 0.5;
sigma_intensity_bilateral = 0.1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate rotationally blurred image
[I_pad, pad_widths] = pad_farthest_corner(I, rot_center);
b = rotate_blur_image(I_pad, blur_th);
b_polar = map_to_polar(b);

% Generate blur PSF
pix_th = (blur_th/360)*size(b_polar,1); % Assuming y axis is theta in polar coordinates 
blur_len = floor(pix_th);
psf = zeros(blur_len*2-1, blur_len*2-1);
psf(1:blur_len,blur_len) = 1;

% Deconvolution
if deconv_method == 'ADMM'
    if prior == 'sparse'
        x_polar = ADMM_sparse(b_polar, psf, lambda, rho, deconv_iters);
    elseif prior == 'tv'
        x_polar = ADMM_TV(b_polar, psf, lambda, rho, deconv_iters);
    end
elseif deconv_method == 'RL'
    if prior == 'none'
        x_polar = RL(b_polar, psf, deconv_iters);
    elseif prior == 'sparse'
        x_polar = RL_sparse(b_polar, psf, lambda, deconv_iters);
    elseif prior == 'tv'
        x_polar = RL_TV(b_polar, psf, lambda, deconv_iters);
    end
elseif deconv_method == 'wiener'
    x_polar = wiener(b_polar, psf, sigma_noise_wiener);
end

% Mapping back to cartesian space
x_cart = map_to_cartesian(x_polar);
x = crop_artifact_portions(x_cart, pad_widths);
x = normalize_01(x)*brightness_scale;

% Bilateral filtering deconvolution artifacts
average_filt_radius = floor((2*sigma_spatial_bilateral+1)/2);
for c = 1:C
    x(:,:,c) = bilateral(x(:,:,c), average_filt_radius, sigma_spatial_bilateral, sigma_intensity_bilateral);
end


gt = crop_artifact_portions(I_pad, pad_widths); % takes portion of original without artifacts

subplot(1,3,1)
imshow(gt)
title('Ground truth')
subplot(1,3,2)
imshow(crop_artifact_portions(normalize_01(b), pad_widths))
title('Simulated blurred image')
subplot(1,3,3)
imshow(x);
title(['Reconstructed image, PSNR = ', num2str(psnr(x, gt))])
        