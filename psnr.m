function[psnr] = psnr(I,x)
MSE = 1/(size(I,1)*size(I,2)*3)*(sum((I-x).^2,'all'));
psnr = 10*log10(max(I,[],'all')^2/MSE);