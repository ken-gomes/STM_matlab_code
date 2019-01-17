function vp = kfinddip(topo, level, border, minarea)
% vp = ltfinddip(record, level, border, minarea)

if nargin < 3, border = 0; end
if nargin < 4, minarea = 4; end

atomdata = regionprops(topo < level);
vp = reshape([atomdata.Centroid],2,length(atomdata))';

% remove one pixel
vp([atomdata.Area] < minarea,:) = [];

% remove those on border
[xl, yl] = size(topo);
vp(vp(:,1) < 1+border,:) = [];
vp(vp(:,1) > xl - border,:) = [];
vp(vp(:,2) < 1+border,:) = [];
vp(vp(:,2) > yl - border,:) = [];



