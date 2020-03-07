function [x] = RL_color(I, psf, max_iters)
    eps = 1e-8;
    I(I<=0) = eps;
    [H,W,C] = size(I);
    
    otf = psf2otf(psf, [H,W]);

    Afun    = @(x) ifft2( fft2(x).*otf, 'symmetric');
    Atfun   = @(x) ifft2( fft2(x).*conj(otf), 'symmetric');
    
    x = rand(size(I));
    for c = 1:C
        for i = 1:max_iters              
            y = I(:,:,c)./Afun(x(:,:,c));
            y(isnan(y)) = 0;
            z = Atfun(y);
            x(:,:,c) = x(:,:,c).*(z./Atfun(ones(H,W)));
            x(isnan(x)) = 0;
            x(x<=0) = eps;
        end
    end
end

