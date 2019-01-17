function kHplot(vp, H, cmsite, cmbond)
% kHplot takes in a list of points (lattice) and a hamiltonian H and plots the
% corresponding lattice of atoms with the potential energies and the "t's"
% color coded based on their value.
% 
% Lattice must be an n x 2 array of x,y values with its first entry 
% corresponding to the first element of the diagonal of the hamiltonian
%  
% Hamiltonian will be an n x n matrix.


if nargin < 4, cmbond=colormap(winter(256)); end
if nargin < 3, cmsite=colormap(autumn(256)); end

%Parameters
linestyle='-';
markersize = 150;
nsite=length(vp);

%Plotting the hopping terms
Ht=triu(H,1);
Ht(Ht==0)= NaN;
cmin=min(min(Ht));
cmax=max(max(Ht));
if cmin==cmax
    Ht=Ht/cmin*128;
else
    Ht=round(255*(Ht-cmin)/(cmax-cmin)+1);
end
for i=1:nsite-1
    for j=i+1:nsite
        if H(i,j)
            line([vp(i,1), vp(j,1)],[vp(i,2), vp(j,2)],'color',cmbond(Ht(i,j),:),'LineStyle',linestyle);
        end
    end
end


% Plotting the on-site potential
V=diag(H);
cmin=min(min(V));
cmax=max(max(V));
if cmin==cmax
    V=V-cmin+128;
else
    V=round(255*(V-cmin)/(cmax-cmin)+1);
end
cmsite=cmsite(V,:);

hold on
scatter(vp(:,1),vp(:,2),markersize,cmsite,'filled');
hold off

% old way to do scatter by hand...
% for i = 1:nsite
%    line(vp(i,1), vp(i,2),'marker','.','color',cmsite(V(i),:),'markersize',markersize);
% end
