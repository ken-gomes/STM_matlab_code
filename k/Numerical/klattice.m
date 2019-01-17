function vp = klattice(nx, ny, a, type)
% generates the position for the CO molecules to form a hexagonal or
% triangular lattice.
% input: nx,ny = number of retangular unit cells
%           a = unit cell lattice constant
%           type = 1 => honeycomb (CO in triangular lattice)
%           type = 2 => triangular (CO in honeycomb)
%           type = 3 => CO in Kagome Lattice
%           type = 4 => tau3 lattice
%           type = vp0 => uses vp0 coordinates as unit cell.



if nargin < 3, a=2.55; end;
if nargin < 4, type=1; end;

% Defines the unit cell

if size(type,1)==1,
    if type == 1, % honeycomb (CO in triangular Lattice)
        vp0=[0, 0; a*sqrt(3)/2, a/2];
    end;
    if type == 2, % Triangular (CO in Honeycomb)
        vp0=[-a/sqrt(3),0; a/sqrt(3),0;-a/sqrt(3)/2,a/2; a/sqrt(3)/2,a/2];
    end;
    if type == 3, % CO in kagome lattice
        vp0=[0, a/2; a*sqrt(3)/4, a/4; a*sqrt(3)/4, -a/4;
            -a*sqrt(3)/4, a/4;-a*sqrt(3)/4, -a/4; a*sqrt(3)/2, 0];
    end;
    if type == 4, % tau3 (CO in honeycomb+ kagome)
        %double honeycomb
        vp0=[0, a/3; 0,-a/3; 
            a/sqrt(3)/2, a/6; -a/sqrt(3)/2, -a/6;
            a/sqrt(3)/2, -a/6; -a/sqrt(3)/2, a/6;
            a/sqrt(3), a/3; a/sqrt(3),-a/3;
            a*sqrt(3)/2, a/6; a*sqrt(3)/2, -a/6;
            2*a/sqrt(3), a/3; 2*a/sqrt(3),-a/3];
        % kagome
        vp0=[vp0; 0, a/2; a*sqrt(3)/4, a/4; a*sqrt(3)/4, -a/4;
            -a*sqrt(3)/4, a/4;-a*sqrt(3)/4, -a/4; a*sqrt(3)/2, 0];
    end;
else
    vp0=type;
end;


% Creating lattice;
vp=[];
for i=floor(-nx/2):floor(nx/2),
    for j=floor(-ny/2):floor(ny/2),
        vp=[vp; vp0+repmat([i*a*sqrt(3), j*a],size(vp0,1),1)];
    end;
end


% Cleaning up the lattices edges
if size(type,1)==1,
if type ==1, vp=sortrows(vp); vp=vp(1:end-ny-1,:); end;

if type ==3, 
    vp=sortrows(vp,2); vp=vp(1+2*(nx+1):end,:);
    vp=sortrows(vp); vp=vp(1:end-(ny+1),:);
end;
if type ==4, 
    vp=sortrows(vp,2); vp=vp(1:end-nx-1,:);
    vp=sortrows(vp); vp=vp(1+4*(ny+1):end-2*(ny+1),:);
end;
end;


