function smap=ksym(map, n, flip)

%   smap=ksym(map, n, flip)
%   generates a symmetrized map (smap)
%   map = input map to be symmetrized
%   n = number of rotations of 180/n degrees
%   flip = add mirror symmetrization (0 for none, 1 by default)

%initialize
if nargin<3, flip=0; end;
smap=map;

% rotation symmetry
for i=1:n-1,
    smap=smap+imrotate(map,i*180/n,'crop');
end;
smap=smap/n;

% mirror symmetry
if flip, smap=(smap+fliplr(smap)+flipud(smap))/3; end;
