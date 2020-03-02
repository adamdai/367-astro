clear, close all
img_path = 'stock_photos/stock_01.jpg';
I = rgb2gray(im2double(imread(img_path)));
I = I(1:500, 1:800);
I = pad_rotate_img(I);
I(I>0.5) = 1;
I(I<=0.5) = 0;

[H,W] = size(I);

%blur_center = [ceil(H/2), ceil(W/2)];
%shift_I = shift_to_center(I, blur_center);

blurred_I = I;
for th = linspace(0,50,100)
    blurred_I = blurred_I + imrotate(I, th, 'nearest', 'crop');
end

%blurred_I = normalize_img(blurred_I);
subplot(1,2,1)
imshow(I);
subplot(1,2,2)
imshow(blurred_I);

function [x] = shift_to_center(x, center)
    shift_dist = [center(1)-ceil(size(x,1)/2), center(2)-ceil(size(x,2)/2)];
    x = circshift(x, shift_dist(1), 1);
    x = circshift(x, shift_dist(2), 2);
    if shift_dist(1) >= 0
        x(1:shift_dist(1),:) = 0;
    else
        x(end-shift_dist(1):end,:) = 0;
    end
    if shift_dist(2) >= 0
        x(:,1:shift_dist(2)) = 0;
    else
        x(:,end-shift_dist(2):end) = 0;
    end
end

function [x] = normalize(x)
    x = (x - min(x, [], 'all'))./max(x, [], 'all');
end

function [x] = pad_rotate_img(x)
    [H,W] = size(x);
    diag_dist = ceil(norm(size(x)));
    x = padarray(x, [ceil((diag_dist-H)/2), ceil((diag_dist-H)/2)]);
end