function [A1,A2]=kspin(n,rin,rout)
% Generates spin rings for the spin selection rules on the FFT
% [A1,A2]=kspin(n,r1,r2)
% n = size of the matrix
% rin = inner radius
% rout = outer radius

A1=zeros(n); 
c=(n+1)/2;

% First spin component
for i=1:n, 
    for j=1:n,
        d=sqrt((i-c)^2+(j-c)^2) ;
        if d>=rin && d<=rout,
            A1(i,j)=(j-c)/d;
        end;
    end;
end;

% Second spin component
A2=rot90(A1);
