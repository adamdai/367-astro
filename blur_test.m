clear, close all

% Get sample image
img_path = 'stock_photos/stock_01.jpg';
I = rgb2gray(im2double(imread(img_path)));
I = I(1:500, 1:500);

% Generate blur PSF
blur_len = 50;
psf = zeros(blur_len*2-1, blur_len*2-1);
psf(1:blur_len,blur_len) = 1/blur_len;

% functions converting a point spread function (convolution kernel) to the
% corresponding optical transfer function (Fouier multiplier)
p2o = @(x) psf2otf(x, size(I));

% precompute OTFs
cFT     = p2o(psf);

% blur image with kernel
Ib = ifft2(fft2(I).*cFT);

% Deconvolution 
I_deconv = wiener(Ib, psf, 0.001);

% find PSNR
MSE = 1/(size(I,1)*size(I,2)*3)*(sum((I-I_deconv).^2,'all'));
PSNR = 10*log10(max(I,[],'all')^2/MSE);
fprintf('RL PSNR = %f \n',PSNR); 