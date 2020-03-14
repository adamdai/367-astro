function [x] = tonemap(I)
    I = I.^0.1;
    Iintensity = (20*I(:,:,1)+40*I(:,:,2)+I(:,:,3)) ./61;
    Ichrominance = cat(3, I(:,:,1)./Iintensity, I(:,:,2)./Iintensity, I(:,:,3)./Iintensity);
    L = log10(Iintensity);
    averageFilterRadius = 5; % Chnage if needed
    sigma               = 1; % Complete
    sigmaIntensity      = 1; % Complete
    B = bilateral(L, averageFilterRadius, sigma, sigmaIntensity);
    D = L-B; % Complete
    dR = 2;
    s = dR / (max(B, [], 'all') - min(B, [], 'all')); % Complete
    BB = (B - max(B, [], 'all')).*s; % Complete
    % Show the scaled base layer
    % See code at end
    % Reconstruct the log intensity:
    O = 10.^(BB+D); % Complete
    x = cat(3, O.*Ichrominance(:,:,1), O.*Ichrominance(:,:,2), O.*Ichrominance(:,:,3)).^(1/2.2); % Complete
end