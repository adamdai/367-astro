clear, close all
addpath('./utility');
addpath('./circlefit');

% REAL DATA
img_path = 'stock_photos/star_trail_3.jpg';
%img_path = 'stock_photos/star_trails.jpeg';
%img_path = 'stock_photos/star_trail_test.jpg';
%img_path = 'stock_photos/star_trail2.jpg';
%I = rgb2gray(im2double(imread(img_path)));
I = im2double(imread(img_path));
%I = I(1:276, 150:415, :);% centered
%I = I(1500:3500, 1:2000, :);% centered
bw = imbinarize(rgb2gray(I));

% SIMULATED DATA
% img_path = 'stock_photos/stock_02.jpg';
% I = im2double(imread(img_path));
% %I = I(1000:3000, 2000:4000, :);
% I = I(1:500, 1:500, :);
% rot_center = [240,220];
% [I_pad, pad_widths] = pad_farthest_corner(I, rot_center);
% blur_th = 15;
% I_blurred = unpad_farthest_corner(normalize_01(rotate_blur_image(I_pad, blur_th)),pad_widths);
% 
% %bw = imbinarize(rgb2gray(I_blurred));
% bw = im2bw(rgb2gray(I_blurred),0.1);
% % bw = rgb2gray(I_blurred);

% tic
% [rows, columns] = find(bw);
% y = rows./size(I,1);
% x = columns./size(I,2);
% [xc,yc,R1,R2] = cvxcircfit(x,y);
% xc = xc*size(I,2);
% yc = yc*size(I,1);
% toc
% imshow(bw);viscircles([xc,yc;xc,yc],[100;200]);

% tic
% [rows, columns] = find(bw);
% [xc,yc,R,a] = circfit(columns,rows);
% toc
% imshow(bw);viscircles([xc,yc],R);

tic
sz = size(I,1)*size(I,2);
s = sqrt(sz/250000);
se = strel('line',1*s,10*s);
bw_dil = imdilate(bw,se);

bw_rescale = imresize(bw_dil,1/s);
[c,r] = imfindcircles(bw_rescale,[10,max(size(bw_rescale))]);
figure();imshow(bw_rescale);viscircles(c(1,:),r(1));
c = c*s;
r = r*s;
toc
figure();imshow(bw);viscircles(c(1,:),r(1));
%figure();imshow(bw);viscircles(c,r);

% figure();
% imshow(I);
% 
% rot_center = [ceil(size(I,1)/2),ceil(size(I,2)/2)];
% I_blurred_polar = map_to_polar(I, size(I,2), size(I,1));
% figure();
% imshow(I_blurred_polar);

% cvx_begin
%     variable c(2)
%     variable r
%     circle = ((rows - c(2)).^2 + (cols - c(1)).^2 <= r.^2+tol) & ((rows - c(2)).^2 + (cols - c(1)).^2 >= r.^2-tol);
%     maximize(sum(I.*circle));
%     subject to
%         0 <= r <= max(H,W);
%         0 <= c(1) <= H;
%         0 <= c(2) <= W;
% cvx_end