function [I_deconv] = RL_TV(I, psf, lambda, max_iters)
    eps = 1e-8;
    I(I<=0) = eps;
    imageSize = [size(I,1) size(I,2)];
    C = size(I,3);
    
    otf = psf2otf(psf, imageSize);

    Afun    = @(x) ifft2( fft2(x).*otf, 'symmetric');
    Atfun   = @(x) ifft2( fft2(x).*conj(otf), 'symmetric');
      
    I_deconv = rand(size(I));
    
    for c = 1:C
        % Initial guess
        x = rand(imageSize);
        At_1 = Atfun(ones(imageSize));
        for i = 1:max_iters
            d = I(:,:,c)./Afun(x);
            d(isnan(d))=0;
            D = opDx(x);
            Dx = D(:,:,1)./abs(D(:,:,1));
            Dy = D(:,:,2)./abs(D(:,:,2));
            TV = lambda*(Dx./abs(Dx)+Dy./abs(Dy));
            TV(isnan(TV))=0;
            x = (Atfun(d)./(At_1-TV)).*x;
            x(x<0)=0;
            fprintf('channel %d, iteration %d\n',c,i);
        end
        I_deconv(:,:,c) = x;
    end
end

