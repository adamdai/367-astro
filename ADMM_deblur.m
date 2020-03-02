clear, close all
img_path = 'stock_photos/stock_01.jpg';
I = rgb2gray(im2double(imread(img_path)));

I = I(1:300, 1:500);

% blur kernel
c_size = 50;
c = zeros(c_size);
c(ceil(c_size)/2:end,ceil(c_size/2)) = 3/c_size;

% functions converting a point spread function (convolution kernel) to the
% corresponding optical transfer function (Fouier multiplier)
p2o = @(x) psf2otf(x, size(I));

% precompute OTFs
cFT     = p2o(c);
cTFT    = conj(p2o(c));

% blur image with kernel
Ib = ifft2(fft2(I).*cFT);

subplot(1,3,1)
imshow(I)
subplot(1,3,2)
imshow(Ib)

% add noise to blurred image
%b = Ib + sigma.*randn(size(I));
b = Ib;

% ADMM
[H,W] = size(I);
iterations = 100;
lamda = 0.1;
rho = 10;
kappa = lamda/rho;

x = zeros(H, W);
z = zeros(H, W);
u = zeros(H, W);

bFT = fft2(b);
denom = cTFT.*cFT + rho;

for iters = 1:iterations
    % x update
    v = z - u;
    vFT = fft2(v);
    num = cTFT.*bFT + rho*vFT;
    x = real(ifft2(num./denom));
    % z update
    w = x + u;
    z = max(w-kappa,0) - max(-w-kappa,0);
    % u update
    u = u + x - z;
end

subplot(1,3,3)
imshow(x)

% find PSNR
MSE = 1/(size(I,1)*size(I,2)*3)*(sum((I-x).^2,'all'));
PSNR = 10*log10(max(I,[],'all')^2/MSE);
fprintf('ADMM with sparisity prior PSNR = %f \n',PSNR); 