function klatticeplot2(vp,NN,color)
% This plots a lattice and the bonds.

if nargin < 3, color=[.5 1 .5]; end;

% Finding the distances between each atoms.
 
% Define matrix marking the neighbors
NN = zeros(nsite);
NN(D < 1.01*a0 & D > 0.99*a0) = 1;

for i=1:nsite
    for j=i:nsite
        if NN(i,j),
            line([vp(i,1), vp(j,1)],[vp(i,2), vp(j,2)],'color',color);
        end
    end
end

