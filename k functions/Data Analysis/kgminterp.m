function out=kgminterp(data1, data2, n, delta)

% outputs a cell with the interpolation between the 2 gapmaps 
%

if nargin<4, delta=30; end;
if nargin<3, n=20;end;
z=3; % this is the zero value for the gap
[d1,d2]=size(data1);
out=cell(n,1);
for i=1:n, out{i}=zeros(d1,d2);end;

for i=1:d1,
    for j=1:d2,
        if data2(i,j)>z || data1(i,j)>delta,
            for k=1:n, 
                out{k}(i,j)=(data1(i,j)*(1-((k-1)/(n-1)))+data2(i,j)*(((k-1)/(n-1))));
            end;
        else
            nzero=round(n*data1(i,j)/delta);
            for k=1:nzero,
                out{k}(i,j)=(data1(i,j)*(1-((k-1)/(nzero-1)))+data2(i,j)*(((k-1)/(nzero-1))));
            end;
            for k=nzero:n,
                out{k}(i,j)=data2(i,j);
            end;
        end;
    end;
end;
