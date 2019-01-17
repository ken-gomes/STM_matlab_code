function klatticeplot(vp,a0,color,linestyle)
% This plots a lattice and the bonds.

if nargin < 3, color=[.2 .2 .2]; end;
if nargin < 4, linestyle='-'; end;

% Finding the distances between each atoms.
[X1, X2] = meshgrid(vp(:,1), vp(:,1));
[Y1, Y2] = meshgrid(vp(:,2), vp(:,2));
D = sqrt((X1 - X2).^2 + (Y1-Y2).^2);
nsite = length(D);
clear X1 X2 Y1 Y2

% if a0 is not given, use n.n. distance
if nargin < 2, a0=min(D(1,2:end)); end;
 
% Define matrix marking the neighbors
NN = zeros(nsite);
NN(D < 1.01*a0 & D > 0.99*a0) = 1;

for i=1:nsite
    for j=i:nsite
        if NN(i,j)
            line([vp(i,1), vp(j,1)],[vp(i,2), vp(j,2)],'color',color,'LineStyle',linestyle);
        end
    end
end

