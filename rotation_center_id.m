clear, close all
addpath('./utility');
img_path = 'stock_photos/star_trail_test.jpg';
%img_path = 'stock_photos/star_trail2.jpg';
%img_path = 'stock_photos/star_trail_3.jpg';
I = rgb2gray(im2double(imread(img_path)));
%I = im2double(imread(img_path));
%I = I(1:276, 150:415, :);% centered
%I = I(1750:2500, 1500:2250, :);% centered

[H,W] = size(I);

[cols,rows] = meshgrid(1:W, 1:H);
tol = 200;

c = [100, 200];
r = 50;
circle = ((rows - c(2)).^2 + (cols - c(1)).^2 <= r.^2+tol) & ((rows - c(2)).^2 + (cols - c(1)).^2 >= r.^2-tol);


%bw = im2bw(I,0.5);
bw = imbinarize(I);
[rows, columns] = find(bw);
[xc,yc,R,a] = circfit(columns,rows);
imshow(bw);viscircles([xc,yc],R);

% [c,r] = imfindcircles(I,[100,4000]);
% imshow(I);viscircles(c,r);

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