function data=klnavg(fname)

% Average the data taken at same point for didv linecuts. 
% Input: fname = file where initial data is after kopen
% Outpot: data = matrix with avg for data on every point.

n1=fname{3}.xsz;                      % # of energies
n2=fname{1}.xsz;                      % # of lines
n3=fname{3}.ysz/n2;                 % # of spec/lines

data=zeros(n1,n2);
for i=1:n1,
    for j=1:n2,
        for k=1:n3,
            data(i,j)=data(i,j) + fname{3}.main(i,(j-1)*n3+k)/n3;
        end;
    end;
end;

% end of file