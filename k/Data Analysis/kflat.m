function data=kflat(mtx, dim)

% data=kflat(mtx, dim)
% remove drift slope from a map. by default it assumes scans along y.
% Input: mtx = map
%           dim = 1 to use a lineslopesubtract 
%           along given direnction
% Output: data = flat map

if nargin<2, dim=0; end;
sz=size(mtx);
data=zeros(sz);
if dim,
    for i=1:sz(1)
        d = mtx(i,:);
        line = lfit(d);
        data(i,:) = mtx(i,:) - line;
    end
else
    data=mtx-repmat(median(mtx,2),1,sz(2));
end
if mean2(abs(data))<10^-8, data=data*10^10;end;
data=data-min(data(:));


function line = lfit(mtx)

l = length(mtx);
p=[ones(l, 1) (1:l)'];
b=p\mtx(:); 
line=b(1)+b(2)*(1:l); 