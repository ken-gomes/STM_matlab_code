function [Sx, Sy]=kSTEMwheel(S,n,r)
% Creates the matrice Sx and Sy with the spin compents for the convolution
% calculations.
% S = spin values. It should be [2,ns] in size. where each line is for the
% spins for the inside and outiside. 
% n = size of desired matrices. n=201 by default. it should be odd.
% r = radius for the inside spin. by default r=17 which works for n=201.

if nargin<3, r=17; end;
if nargin<2, n=201; end;
ns=size(S,2);
Sx=zeros(n); Sy=zeros(n); 
c=(n+1)/2;

for i=1:n, 
    for j=1:n,
        d=sqrt((i-c)^2+(j-c)^2);
        if d==0, 
            theta=1;
        else
            theta=round(atan2((i-c),(j-c))*ns/(2*pi)+ns/2+1); theta(theta==ns+1)=1;
        end;
        if d<=r
            Sx(i,j)=cos(S(1,theta));
            Sy(i,j)=sin(S(1,theta));
        else
            Sx(i,j)=cos(S(2,theta));
            Sy(i,j)=sin(S(2,theta));
        end;
    end;
end;