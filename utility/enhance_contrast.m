function [x] = enhance_contrast(I, max_lum)
    I_lab = rgb2lab(I);
    L = I_lab(:,:,1)./max_lum;
    I_lab_adapthisteq = I_lab;
    I_lab_adapthisteq(:,:,1) = adapthisteq(L)*max_lum;
    x = lab2rgb(I_lab_adapthisteq);
end