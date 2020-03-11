clear, close all
addpath('./deconvolution_funcs');
addpath('./utility');

stock_imgs = [1,2,5];
rot_centers = [355, 818; 1772, 1110; 1450, 524];
blur_th = [5, 10, 15];

for i = 1:3
    imgpath = ['./stock_photos/stock_0',num2str(stock_imgs(i)),'.jpg'];
    I = im2double(imread(imgpath));
    I = I(1:2000, 1:2000, :);
    rot_center = rot_centers(i,:);
    [I_pad, pad_widths] = pad_farthest_corner(I, rot_center);
    [H_pad, W_pad, C_pad] = size(I_pad);
    b = normalize_01(rotate_blur_image(I_pad, blur_th(i)));
    b = unpad_farthest_corner(b, pad_widths);
    imwrite(b, ['test_circle_detect_images/sim_blur',num2str(i),'.jpg']);
end