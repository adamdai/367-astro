function[x] = wiener(I, psf, sigma)

% convert psf to otf
otf = psf2otf(psf, size(I));
% prevent division by 0 
eps = 1e-8;
otf(otf==0) = eps;

% Wiener
SNR = mean(I,'all')/sigma;
x = ifft2((abs(otf).^2./(abs(otf).^2+1/SNR)).*(fft2(I)./otf));