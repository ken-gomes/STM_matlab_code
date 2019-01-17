function LDOS = kspec(atoms, points, V, delta, dispersion)
% LDOS = kspec(atoms, points, V, delta, dispersion) 
% Calculates the conductance spectrum 
% atoms = locations of scattering atoms
% points = locations to take spectra at
% V = vector of voltages to evaulate LDOS over
% delta: scattering phase shift (default i*Inf) or 'Kondo' for energy-dependent shift
% dispersion = either [E0, m*] or [] for usual quadratic fit
%

if nargin < 2, points = [0 0]; end
if nargin < 3 || isempty(V), V = linspace(-0.4, 0.4, 401); end
if nargin < 4 || isempty(delta) || isinf(delta) || isnan(delta)
    % If no phase shift is specified, use the black dot limit (phase = i*infinity)
    phase_factor = -1/2;
elseif ~ischar(delta)
    phase_factor = (exp(2*1i*delta) - 1)/2;
else  % Kondo: energy-dependent phase shift from Fiete & Heller 2001
    delta_bg = pi/4; delta_2 = 1i*3/2; gamma = .009;
    delta = delta_bg + delta_2 + atan(V / (gamma/2));
    phase_factor = (exp(2*1i*delta) - 1)/2;
end
if length(phase_factor) == 1
    phase_factor = phase_factor * ones(size(V));
end

% Evaluate the inverse dispersion relation
if nargin < 5, dispersion =[]; end
k_vector = kv2k(V, dispersion);

if any(~isreal(k_vector))
    error('Imaginary k found. Your voltage is probably out of range.'); end
if any(k_vector == 0)
    error('k = 0 found. Your voltage needs to start above the band edge.'); end

n_atoms = size(atoms, 1);
n_points = size(points, 1);
LDOS = zeros(length(k_vector),n_points);
I_matrix = eye(n_atoms);

% Compute distances between pairs of atoms
prd=atoms*atoms'; sqr=diag(prd); 
R = sqrt(sqr*ones(1,n_atoms) + ones(n_atoms,1)*sqr' - 2*prd);

r = zeros(n_atoms, n_points);
for j=1:n_points
    r(:,j) = sqrt(sum((ones(n_atoms,1)*points(j,:) - atoms).^2,2));
end

% create a lookup table for the bessel function
res = 0.01;
dkr = min(k_vector) * res;
maxkr = max(k_vector) * max([R(:); r(:)]) + dkr;
Htable= besselh(0,(0:dkr:maxkr));
Htable(1)=0;    

for j=1:n_points
    for index = 1:length(k_vector)
        k = k_vector(index);
        H0vector = Htable(round(r(:,j)*k/dkr + 1));
        LDOS(index,j) = 1+real(phase_factor(index)*H0vector *...
            ((I_matrix - Htable(round(R*k/dkr + 1))*phase_factor(index)) \ H0vector.')  );
    end
end
    