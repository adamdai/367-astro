clear, close all
addpath('./deconvolution_funcs');

% Get sample image
img_path = 'stock_photos/stock_01.jpg';
% I = rgb2gray(im2double(imread(img_path)));
% I = I(1:500, 1:500);
I = im2double(imread(img_path));
I = I(1:400, 1:500, :);

% Generate blur PSF
% blur_len = 50;
% psf = zeros(blur_len*2-1, blur_len*2-1);
% psf(1:blur_len,blur_len) = 1/blur_len;

% blur kernel
psf_size = 50;
psf = zeros(psf_size);
psf(ceil(psf_size)/2:end,ceil(psf_size/2)) = 3/psf_size;

% functions converting a point spread function (convolution kernel) to the
% corresponding optical transfer function (Fouier multiplier)
p2o = @(x) psf2otf(x, size(I));

% precompute OTFs
cFT     = p2o(psf);

% blur image with kernel
Ib = ifft2(fft2(I).*cFT);

% Deconvolution 
I_deconv = RL_TV_color(Ib, psf, 0.01, 100);
%I_deconv = ADMM_TV_color(Ib, psf, 0.01, 10, 100);

subplot(1,2,1)
imshow(I)
title('Original')
subplot(1,2,2)
imshow(I_deconv)
title('Reconstructed image')

% find PSNR
fprintf('PSNR = %f \n',psnr(I,I_deconv)); 