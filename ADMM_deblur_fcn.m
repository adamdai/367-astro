function [x] = ADMM_deblur_fcn(b, c_size, lambda, rho, iterations)
    % blur kernel
    c = zeros(c_size);
    c(ceil(c_size/2):end,ceil(c_size/2)) = 1/c_size;

    % functions converting a point spread function (convolution kernel) to the
    % corresponding optical transfer function (Fourier multiplier)
    p2o = @(x) psf2otf(x, size(b));

    % precompute OTFs
    cFT     = p2o(c);
    cTFT    = conj(p2o(c));
    
    % ADMM
    [H,W] = size(b);
%     iterations = 100;
%     lamda = 0.001;
%     rho = 10;
    kappa = lambda/rho;

    x = zeros(H, W);
    z = zeros(H, W);
    u = zeros(H, W);

    bFT = fft2(b);
    denom = cTFT.*cFT + rho;

    for iters = 1:iterations
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
end

