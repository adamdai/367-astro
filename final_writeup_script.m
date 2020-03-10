clear, close all
addpath('./deconvolution_funcs');
addpath('./utility');

imgpath = './stock_photos/stock_02.jpg';
I = im2double(imread(imgpath));
I = I(1:2000, 1:2000, :);
[H, W, C] = size(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% PARAMETERS %%%%%%%%%%%%%%
blur_th = 15;
rot_center = [ceil(H/2),ceil(W/2)];
deconv_method = 'ADMM';
prior = 'sparse';
deconv_iters = 5;
lambda = 1;
rho = 10;
sigma_noise_wiener = 1.55;
brightness_scale = 1.55;
contrast_scale = 5;
sigma_spatial_bilateral = 0.5;
sigma_intensity_bilateral = 0.1;
noise_thresh = 0.2;
max_lum = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Generate rotationally blurred image
[I_pad, pad_widths] = pad_farthest_corner(I, rot_center);
[H_pad, W_pad, C_pad] = size(I_pad);
b = rotate_blur_image(I_pad, blur_th);

tic % start timer for algorithm

b(b<noise_thresh) = 0;
b_polar = map_to_polar(b);

% Generate blur PSF
pix_th = (blur_th/360)*size(b_polar,1); % Assuming y axis is theta in polar coordinates 
blur_len = floor(pix_th);
psf = zeros(blur_len*2-1, blur_len*2-1);
psf(1:blur_len,blur_len) = 1;

% Deconvolution
switch deconv_method
    case 'ADMM'
        switch prior
            case 'sparse'
                x_polar = ADMM_sparse(b_polar, psf, lambda, rho, deconv_iters);
            case 'tv'
                x_polar = ADMM_TV(b_polar, psf, lambda, rho, deconv_iters);
        end
    case 'RL'
    switch prior
        case 'none'
            x_polar = RL(b_polar, psf, deconv_iters);
        case 'sparse'
            x_polar = RL_sparse(b_polar, psf, lambda, deconv_iters);
        case 'tv'
            x_polar = RL_TV(b_polar, psf, lambda, deconv_iters);
    end
    case 'wiener'
        x_polar = wiener(b_polar, psf, sigma_noise_wiener);
end

% Mapping back to cartesian space
x = map_to_cartesian(x_polar, H_pad, W_pad);
x = crop_artifact_portions(x, pad_widths);
x_orig = x;
x = (normalize_01(x_orig)*brightness_scale).^(contrast_scale);

total_time = toc;

% Bilateral filtering deconvolution artifacts
% average_filt_radius = floor((2*sigma_spatial_bilateral+1)/2);
% for c = 1:C
%     x(:,:,c) = bilateral(x(:,:,c), average_filt_radius, sigma_spatial_bilateral, sigma_intensity_bilateral);
% end

gt = crop_artifact_portions(I_pad, pad_widths); % takes portion of original without artifacts

figure('position',[800,800,1500,500]);
subplot(1,3,1)
imshow(gt)
% imwrite(gt, 'results/stock02_ground_truth.jpg');
title('Ground truth')
subplot(1,3,2)
imshow(crop_artifact_portions(normalize_01(b), pad_widths))
imwrite(normalize_01(b), ['results/stock02_blurred_',num2str(blur_th),'deg.jpg']);
title(['Simulated blurred image, \theta = ', num2str(blur_th),'^{o}'])
subplot(1,3,3)
imshow(x);
imwrite(x, ['results/stock02_',deconv_method,'_',prior,'_',num2str(blur_th),'deg.jpg']);
title(['Reconstructed image, PSNR = ', num2str(psnr(x, gt))])

fileinfo = ['results/stock02_',deconv_method,'_',prior,'_',num2str(blur_th),'deg_figure'];
saveas(gcf, [fileinfo,'.jpg']);
metafileID = fopen([fileinfo,'.txt'], 'w');
fprintf(metafileID, 'image = stock02.jpg\n');
fprintf(metafileID, 'crop = 1:2000 x 1:2000\n');
fprintf(metafileID, ['blur angle (deg) = ',num2str(blur_th),'\n']);
fprintf(metafileID, ['rotation center = image center\n']);
fprintf(metafileID, ['deconv method = ',deconv_method,'\n']);
fprintf(metafileID, ['prior = ',prior,'\n']);
fprintf(metafileID, ['deconv iters = ',num2str(deconv_iters),'\n']);
fprintf(metafileID, ['lambda = ',num2str(lambda),'\n']);
fprintf(metafileID, ['rho = ',num2str(rho),'\n']);
fprintf(metafileID, ['brightness scale = ',num2str(brightness_scale),'\n']);
fprintf(metafileID, ['contrast scale = ',num2str(contrast_scale),'\n']);
fprintf(metafileID, ['noise thresh = ',num2str(noise_thresh),'\n']);
fprintf(metafileID, ['psnr = ',num2str(psnr(x,gt)),'\n']);
fprintf(metafileID, ['execution time (s) = ',num2str(total_time),'\n']);
fclose(metafileID);

        