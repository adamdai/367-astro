function [x] = ADMM_TV(b, psf, lambda, rho, iterations)
    
    % convolution kernel for Dx and Dy
    dy = [0 0 0; 0 -1 0; 0 1 0];
    dx = [0 0 0; 0 -1 1; 0 0 0];

    % functions converting a point spread function (convolution kernel) to the
    % corresponding optical transfer function (Fourier multiplier)
    p2o = @(x) psf2otf(x, size(b));

    % precompute OTFs
    cFT     = p2o(psf);
    cTFT    = conj(p2o(psf));
    dxFT    = p2o(dx);
    dxTFT   = conj(p2o(dx));
    dyFT    = p2o(dy);
    dyTFT   = conj(p2o(dy));
    
    % ADMM
    [H,W] = size(b);
    kappa = lambda/rho;

    x = zeros(H, W);
    z = zeros(H, W, 2);
    u = zeros(H, W, 2);

    bFT = fft2(b);
    denom = cTFT.*cFT + rho*(dxTFT.*dxFT + dyTFT.*dyFT);

    for iters = 1:iterations
        % x update
        v = z - u;
        v1FT = fft2(v(:,:,1));
        v2FT = fft2(v(:,:,2));
        num = cTFT.*bFT + rho*(dxTFT.*v1FT + dyTFT.*v2FT);
        x = real(ifft2(num./denom));
        % update Dx
        xFT = fft2(x);
        Dx = cat(3,real(ifft2(dxFT.*xFT)),real(ifft2(dyFT.*xFT)));
        w = Dx + u;
        % z update
        kappa = lambda/rho;
        z = max(w-kappa,0) - max(-w-kappa,0);
        % u update
        u = u + Dx - z;
    end
end

