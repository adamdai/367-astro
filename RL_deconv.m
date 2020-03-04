function [x] = RL_deconv(I, psf, max_iters)
    eps = 1e-8;
    I(I<=0) = eps;
    
    otf = psf2otf(psf, size(I));

    Afun    = @(x) ifft2( fft2(x).*otf, 'symmetric');
    Atfun   = @(x) ifft2( fft2(x).*conj(otf), 'symmetric');
      
    x = rand(size(I));
    for i = 1:max_iters              
        y = I./Afun(x);
        y(isnan(y)) = 0;
        z = Atfun(y);
        x = x.*(z./Atfun(ones(size(x))));
        x(isnan(x)) = 0;
        x(x<=0) = eps;
    end
end

