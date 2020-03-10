function [x] = enhance_contrast(I)
    I_lab = rgb2lab(I);
    L = I_lab(:,:,1)./100;
    I_lab(:,:,1) = imadjust(L).*100;
    x = lab2rgb(I_lab);
end