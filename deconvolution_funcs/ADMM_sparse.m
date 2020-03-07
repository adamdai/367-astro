function [I_deconv] = ADMM_sparse(I, psf, lambda, rho, iterations)

    % functions converting a point spread function (convolution kernel) to the
    % corresponding optical transfer function (Fourier multiplier)
    p2o = @(x) psf2otf(x, size(I));

    % precompute OTFs
    cFT     = p2o(psf);
    cTFT    = conj(p2o(psf));
    
    % ADMM
    [H,W] = size(I);
    kappa = lambda/rho;

    I_deconv = zeros(H, W);
    z = zeros(H, W);
    u = zeros(H, W);

    bFT = fft2(I);
    denom = cTFT.*cFT + rho;

    for iters = 1:iterations
        % x update
        v = z - u;
        vFT = fft2(v);
        num = cTFT.*bFT + rho*vFT;
        I_deconv = real(ifft2(num./denom));
        % z update
        w = I_deconv + u;
        z = max(w-kappa,0) - max(-w-kappa,0);
        % u update
        u = u + I_deconv - z;
    end
end

