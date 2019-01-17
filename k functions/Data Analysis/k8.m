function [n8, sigma]=k8(hint, delta, hzero, t)

% [n8, sigma]=k8(hint, delta, hzero, t)
% Calculates the number "8" using a least squares fitting
% 
%

hi=interp(hint,10);
hx=interp(delta,10);
n=size(hzero,1);
y=zeros(n,1);

for i=1:n,
    j=1;
    while (hi(j)-hzero(i))<0, 
        j=j+1;
    end;
    y(i)=hx(j);
end;

n8=(y'*t)/norm(t)^2;
sigy=norm(y-n8*t)/sqrt(n-1);
n8=23.2099*n8;
sigma=23.2099*sigy/norm(t);
        