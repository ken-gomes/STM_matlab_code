function out=kcorr(data1, data2, x, y)

% calculates the 2d correlation between 2 square matrix; 
% Input: data1 and data2 = matrice to correlate
%        x and y (optinal) = correlates (data1(i,j) to data2(i+x,j+y))
%        x (without y, optional) = returns a vector with with correlation
%        from 0 up to x;
% Output: with 2 or 4 inputs: the correlation is a scalar;
%         with 3 inputs: the correlation is a vector;

if nargin==2,
    out= corr2(data1,data2);
elseif nargin ==4,
    ds1=size(data1,1);
    ds2=size(data1,2);
    x1=abs(x); y1=abs(y);
    d1=data1(1+x1:ds1-x1,1+y1:ds2-y1);
    d2=data2(1+x1+x:ds1-x1+x,1+y1+y:ds2-y1+y);
    out=corr2(d1,d2);
elseif nargin==3,
    out=zeros(x+1,1);
    out(1)=kcorr(data1,data2);
    for i=1:x,
        for j=-i:i,
            out(i+1)=out(i+1,1)+kcorr(data1,data2,j,round(sqrt(i^2-j^2)))+kcorr(data1,data2,j,-round(sqrt(i^2-j^2)));
        end;
        out(i+1)=out(i+1,1)-kcorr(data1,data2,i,0)-kcorr(data1,data2,-i,0);
        out(i+1)=out(i+1,1)/4/i;
    end;
end;
