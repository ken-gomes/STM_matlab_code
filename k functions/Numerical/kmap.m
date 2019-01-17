
function LDOS = kmap(rs, d, V, npts, delta, dispersion)
% Calculates the LDOS map for set of scatters.
% inputs: rs = vector with the position of the scatters (in A)
%            d = size of the map in A. (200A by default)
%            V = bias voltage in V (0 by default)
%            npts = number of pixels of the map (201 by default)
%            delta = phase change in the scattering (i*infinity by default)

% Parameters
if nargin < 5 || isempty(delta) || isinf(delta) || isnan(delta)
    f = -1/2;   % delta =  i infinity
else
    f = (exp(2*sqrt(-1)*delta)-1)/2;
end
% Evaluate the inverse dispersion relation
if nargin < 5, dispersion =[]; end
if nargin < 4, npts = 201; end
if nargin < 3
    k = 0.21185; 
else 
    k = kv2k(V, dispersion); 
end
if nargin < 2, d=200; end
x = linspace(-d/2, d/2, npts); [X,Y] = meshgrid(x); % axis for positions
ns=size(rs,1); % number of scatters

%build lookup table for bessel functions (speeds up the calculation)
res = 0.01;
max_r = sqrt(2)*d;
Htable= besselh(0,(0:res:max_r)*k);
Htable(1)=0;

% Compute distances between pairs of atoms
prd=rs*rs'; sqr=diag(prd); 
RS = sqrt(sqr*ones(1,ns) + ones(ns,1)*sqr' - 2*prd);

% All now is to calculate Re[f*h*(1-f*H)^-1 *h]
A = f*Htable(round(RS/res)+1);
A(isnan(A)) = 0;
B = inv(eye(ns) - A);

% This for loop is faster than some 3D meshgrid
r = zeros(npts, npts, ns);
for i=1:ns
    r(:,:,i) = sqrt((X - rs(i,1)).^2 + (Y - rs(i,2)).^2);
end

% How the following code works:
% H0tensor will describe the propagation from each point in the scan (from
% the stm tip) to an atom. Each page will be for a different atom.
htensor = Htable(round(r/res)+1);

% To vectorize the calculation, reshape this. Now make a matrix where
% each column corresponds to an atom, and each scan point is a row.
htensor = reshape(htensor, npts^2, ns);

% Now I can compute the Green's function by computing the propagation
% from the tip to an atom, between the atoms, and back to the tip. The sum
% adds the contributions from starting with each atom.
C = sum((htensor * B) .* htensor, 2);
C = reshape(C, npts, npts);

LDOS = 1+real(f*C);
