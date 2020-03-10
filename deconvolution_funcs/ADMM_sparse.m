function [I_deconv] = ADMM_sparse(I, psf, lambda, rho, iterations)
    [H,W,C] = size(I);
    cFT = psf2otf(psf, [H,W]);
    cTFT = conj(cFT);
    
    I_deconv = zeros(size(I));

    kappa = lambda/rho;
    
    for c = 1:C
        x = zeros(H, W);
        z = zeros(H, W);
        u = zeros(H, W);

        bFT = fft2(I(:,:,c));
        denom = cTFT.*cFT + rho;

        for iters = 1:iterations
            disp(['Iteration ',num2str(iters+(c-1)*iterations),' of ',num2str(C*iterations)]);
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