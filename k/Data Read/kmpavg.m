function out=kmpavg(fname,n2)

% Average the data taken at same point for didv maps. 
% Input: fname = file where initial data is after kopen
% Outpot: out = cell with all maps
% it uses kreshape

n1=fname{3}.xsz;                       % # of energies
if nargin<2, n2=fname{1}.xsz*fname{1}.ysz; end;  % # of pixels
n3=fname{3}.ysz/n2;                   % # of spec/pixels
mtx=fname{3}.main;

data=zeros(n1,n2);
for i=1:n1,
    for j=1:n2,
        for k=1:n3,
            data(i,j)=data(i,j)+mtx(i,(j-1)*n3+k)/n3;
        end;
    end;
end;
out=cell(n1,1);
for i=1:n1,
    out{i}=reshape(data(i,:),sqrt(n2),sqrt(n2));
end;




% end of file
