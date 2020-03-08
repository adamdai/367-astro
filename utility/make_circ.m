function [I] = make_circ(r, H, W)
    I = zeros(H, W);
    o = [ceil(H/2), ceil(W/2)];
    for i = 1:H
        for j = 1:W
            if sqrt((o(1)-i)^2+(o(2)-j)^2) < r
                I(i,j) = 1;
            end
        end
    end
end
