function data = ksmooth(ArrayData, r, sigma)

% smooths maps.
% Input: ArrayData = matrix to be smoothed
%           r= radius of smoothing
%           sigma = intensity of smoothing
% Outpot: data = smoothed version of data

if nargin==1, r=1; sigma=1; end;
if nargin==2, sigma=r; end;

[m, n]=size(ArrayData);

filtinit=zeros(m,n);
data=zeros(m,n);

for a=1:m
    for b=1:n
        norm=0;
        for c=a-r:a+r
            for d=b-r:b+r
                if (c > 0) && (c <= m) && (d > 0) && (d <=n) 
                    filtinit(a,b) = filtinit(a,b)+ArrayData(c,d)*exp(-((c-a)^2+(d-b)^2)/2/sigma^2);
                    norm = norm + exp(-((c-a)^2+(d-b)^2)/2/sigma^2);
                end
            end
        end
        data(a,b)=filtinit(a,b)/norm;
    end
end