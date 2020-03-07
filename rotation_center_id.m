clear, close all
img_path = 'stock_photos/star_trail_test.jpg';
I = rgb2gray(im2double(imread(img_path)));
%I = im2double(imread(img_path));

[H,W] = size(I);

[cols,rows] = meshgrid(1:W, 1:H);
tol = 200;

c = [100, 200];
r = 50;
circle = ((rows - c(2)).^2 + (cols - c(1)).^2 <= r.^2+tol) & ((rows - c(2)).^2 + (cols - c(1)).^2 >= r.^2-tol);

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

stats = regionprops('table',I,'Centroid',...
    'MajorAxisLength','MinorAxisLength');