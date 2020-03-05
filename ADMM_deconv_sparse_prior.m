function [I_deconv] = ADMM_deconv_sparse_prior(I, psf, max_iters)
    [H,W,C] = size(I);
    cFT = psf2otf(psf, [H,W]);
    cTFT = conj(cFT);
    
    I_deconv = zeros(size(I));

    lamda = 0.001;
    rho = 10;
    kappa = lamda/rho;
    
    for c = 1:C
        x = zeros(H, W);
        z = zeros(H, W);
        u = zeros(H, W);

        bFT = fft2(I(:,:,c));
        denom = cTFT.*cFT + rho;

        for iters = 1:max_iters
            % x update
            v = z - u;
            vFT = fft2(v);
            num = cTFT.*bFT + rho*vFT;
            x = real(ifft2(num./denom));
            % z update
            w = x + u;
            z = max(w-kappa,0) - max(-w-kappa,0);
            % u update
            u = u + x - z;
        end
        I_deconv(:,:,c) = x;
    end
end