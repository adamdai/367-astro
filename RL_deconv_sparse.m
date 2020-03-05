function [x] = RL_deconv_sparse(I, psf, max_iters)
    eps = 1e-8;
    I(I<=0) = eps;
    
    otf = psf2otf(psf, size(I));

    Afun    = @(x) ifft2( fft2(x).*otf, 'symmetric');
    Atfun   = @(x) ifft2( fft2(x).*conj(otf), 'symmetric');
      
    x = rand(size(I));
    At_1 = Atfun(ones(size(x)));
    lambda = 0.01;
    for i = 1:max_iters              
        y = I./Afun(x);
        y(isnan(y)) = 0;
        z = Atfun(y);
        sp = lambda*(x./abs(x));
        sp(isnan(sp))=0;
        x = x.*(z./(At_1-sp));
        x(isnan(x)) = 0;
        x(x<=0) = eps;
    end
end

