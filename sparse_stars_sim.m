imgres = [600 800];
img = zeros(imgres);
%imshow(img);

% blur kernel
c_size = 50;
c = zeros(c_size);
c(ceil(c_size/2),:) = 5/c_size;

% functions converting a point spread function (convolution kernel) to the
% corresponding optical transfer function (Fouier multiplier)
p2o = @(x) psf2otf(x, imgres);

% precompute OTFs
cFT     = p2o(c);
cTFT    = conj(p2o(c));

% uniform random distribution
% star = 1 pixel
p=0.001;
A=(rand(imgres)<p);
%imshow(A)
imwrite(A,'simulated_data/unif_rand_1px.png');

Ab = ifft2(fft2(A).*cFT);
imshow(Ab)
imwrite(A,'simulated_data/unif_rand_1px_blurred.png');