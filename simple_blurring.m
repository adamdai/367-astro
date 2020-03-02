clear, close all
img_path = 'stock_photos/stock_01.jpg';
I = rgb2gray(im2double(imread(img_path)));

I = I(1:300, 1:500);

blur_I = Afun(I);

subplot(1,3,1)
imshow(I)
subplot(1,3,2)
imshow(blur_I)

% ADMM
[H,W] = size(I);
b = Afun(I);
admm_iters = 25;
pcg_iters = 50;
tol = 1e-12;
lam = 0.1;
rho = 10;
kap = lam/rho;

x = zeros(H, W);
z = zeros(H, W);
u = zeros(H, W);
Atildefun = @(x) reshape(Atfun(Afun(reshape(x, [H,W]))) + rho*reshape(x, [H,W]), [H*W,1]);

for iters = 1:admm_iters 
    % x update
    v = z-u;
    btilde = Atfun(b) + rho*v;
    x = pcg(Atildefun, reshape(btilde, [H*W,1]), tol, pcg_iters);
    x = reshape(x, [H,W]);
    % z update
    v = x+u;
    z = (v-kap).*(v > kap) + (v+kap).*(v < (-1*kap));
    % u update
    u = u + x - z;
end

subplot(1,3,3)
imshow(x)


function [y] = Afun(x)
    c_size = 25;
    c = zeros(c_size);
    c(ceil(c_size/2),:) = 3/c_size;
    c_f = psf2otf(c, size(x));
    y = zeros(size(x));
    y = ifft2(c_f.*fft2(x));
end

function [y] = Atfun(x)
    c_size = 25;
    ct = zeros(c_size);
    ct(:,ceil(c_size/2)) = 3/c_size;
    ct_f = psf2otf(ct, size(x));
    y = zeros(size(x));
    y = ifft2(ct_f.*fft2(x));
end