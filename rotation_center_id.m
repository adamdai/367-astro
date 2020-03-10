clear, close all
addpath('./utility');
img_path = 'stock_photos/star_trail_3.jpg';
%img_path = 'stock_photos/star_trails.jpeg';
%img_path = 'stock_photos/star_trail_test.jpg';
%img_path = 'stock_photos/star_trail2.jpg';
%I = rgb2gray(im2double(imread(img_path)));
I = im2double(imread(img_path));
%I = I(1:276, 150:415, :);% centered
%I = I(1700:3100, 1000:2600, :);% centered
bw = imbinarize(rgb2gray(I));

% test circle points
% imageSizeX = 640;
% imageSizeY = 480;
% [cols,rows] = meshgrid(1:imageSizeX, 1:imageSizeY);
% % Next create the circle in the image.
% c = [320,240];
% r = 100;
% tol = 50;
% circle = ((rows - c(2)).^2 + (cols - c(1)).^2 <= r.^2+tol) & ((rows - c(2)).^2 + (cols - c(1)).^2 >= r.^2-tol);
% % circlePixels is a 2D "logical" array.
% % Now, display it.
% image(circle);
% [rows, columns] = find(circle);
% [xc,yc,R,a] = cvxcircfit(columns,rows);
% imshow(circle);viscircles([xc,yc],R);

tic
[rows, columns] = find(bw);
[xc,yc,R1,R2] = cvxcircfit(columns,rows);
toc
imshow(bw);viscircles([xc,yc;xc,yc],[R1;R2]);

% tic
% [rows, columns] = find(bw);
% [xc,yc,R,a] = circfit(columns,rows);
% toc
% imshow(bw);viscircles([xc,yc],R);

% tic
% bw_rescale = imresize(bw,1/10);
% [c,r] = imfindcircles(bw_rescale,[10,max(size(bw_rescale))]);
% toc
% imshow(bw);viscircles(c(1,:),r(1));

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