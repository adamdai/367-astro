function [I_deconv] = RL_sparse(I, psf, lambda, max_iters)
    eps = 1e-8;
    I(I<=0) = eps;
    [H,W,C] = size(I);
    
    otf = psf2otf(psf, size(I));

    Afun    = @(x) ifft2( fft2(x).*otf, 'symmetric');
    Atfun   = @(x) ifft2( fft2(x).*conj(otf), 'symmetric');
      
    I_deconv = rand(size(I));
    for c = 1:C
        x = I_deconv(:,:,c);
        At_1 = Atfun(ones(size(x)));
        for i = 1:max_iters
            disp(['Iteration ',num2str(i+(c-1)*max_iters),' of ',num2str(C*max_iters)]);
            y = I(:,:,c)./Afun(x);
            y(isnan(y)) = 0;
            z = Atfun(y);
            sp = lambda*(x./abs(x));
            sp(isnan(sp))=0;
            x = x.*(z./(At_1-sp));
            x(isnan(x)) = 0;
            x(x<=0) = eps;
        end
    end
end

