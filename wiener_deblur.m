clear, close all
img_path = 'stock_photos/stock_01.jpg';
I = rgb2gray(im2double(imread(img_path)));

I = I(1:500, 1:500);

% blur kernel
c_size = 25;
c = zeros(c_size);
c(ceil(c_size/2),:) = 3/c_size;

% functions converting a point spread function (convolution kernel) to the
% corresponding optical transfer function (Fouier multiplier)
p2o = @(x) psf2otf(x, size(I));

% precompute OTFs
cFT     = p2o(c);
cTFT    = conj(p2o(c));

cFT = cFT + 0.001;

% blur image with kernel
Ib = ifft2(fft2(I).*cFT);

% add noise to blurred image
sigma = 0.001;
b = Ib + sigma.*randn(size(I));
%b = Ib;

% Wiener
SNR = mean(b,'all')/sigma;
filtered = ifft2((abs(cFT).^2./(abs(cFT).^2+1/SNR)).*(fft2(b)./cFT));
imshow(filtered)
img_name = sprintf('wiener_filtering_%d.png',sigma);
imwrite(filtered,img_name);

% find PSNR
MSE = 1/(size(I,1)*size(I,2)*3)*(sum((I-filtered).^2,'all'));
PSNR = 10*log10(max(I,[],'all')^2/MSE);
fprintf('Wiener Filtering PSNR = %f \n',PSNR); 
