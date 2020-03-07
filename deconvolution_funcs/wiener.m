function[x] = wiener(b, psf, sigma)

% convert psf to otf
otf = psf2otf(psf, size(b));
% prevent division by 0 
eps = 1e-8;
otf(otf==0) = eps;

% Wiener
SNR = mean(b,'all')/sigma;
x = real(ifft2((abs(otf).^2./(abs(otf).^2+1/SNR)).*(fft2(b)./otf)));