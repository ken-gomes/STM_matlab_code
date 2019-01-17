function pos = kCO(Z,COz)
% find CO locations in a topo Z.
Z=Z-min(Z(:));
if nargin<2, COz=0.1; end;
I = Z < COz;
I = bwlabel(I);
atomdata = regionprops(I);
pos = reshape([atomdata.Centroid],2,length(atomdata));
pos = sortrows(pos',2);