% ----------------------------------------
% Tests center of rotation detection methods
% - Least-squares
% - CVX methods
% - Hough transform
% ----------------------------------------

clear, close all
addpath('./utility');
addpath('./circlefit');

img_path = 'test_circle_detect_images/real_blur2.jpg';
I = im2double(imread(img_path));
bw = imbinarize(rgb2gray(I));

center_method = 'hough';

switch center_method
    case 'ls'
        [rows, columns] = find(bw);
        [xc,yc,R,a] = circfit(columns,rows);
        imshow(I);viscircles([xc,yc],R);
        disp(round([xc,yc]));
    case 'cvx'
        [rows, columns] = find(bw);
        y = rows./size(I,1);
        x = columns./size(I,2);
        [xc,yc,R1,R2] = cvxcircfit(x,y);
        xc = xc*size(I,2);
        yc = yc*size(I,1);
        imshow(I);viscircles([xc,yc;xc,yc],[100;200]);
        disp(round([xc,yc]));
    case 'hough'
        [c,r] = houghfit(I);
        figure();imshow(I);viscircles(c(1,:),r(1));
        disp(round(c(1,:)));
end
