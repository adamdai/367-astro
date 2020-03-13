function [xc,yc,R,u] = algcircfit(x,y)
% Algebraic center

n=length(x);  
B = [x.^2+y.^2, x, y, ones(n,1)];
[U,S,V] = svd(B);
u = V(:,end);
xc = -.5*u(2)/u(1);
yc = -.5*u(3)/u(1);
R  =  sqrt((u(2)^2+u(3)^2)/(4*u(1)^2)-u(4)/u(1));
