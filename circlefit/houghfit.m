function [c,r] = houghfit(I)

bw = imbinarize(rgb2gray(I));

sz = size(I,1)*size(I,2);
s = sqrt(sz/250000);
se = strel('line',1*s,10*s);
bw_dil = imdilate(bw,se);

bw_rescale = imresize(bw_dil,1/s);
[c,r] = imfindcircles(bw_rescale,[10,max(size(bw_rescale))]);
c = c*s;
r = r*s;
