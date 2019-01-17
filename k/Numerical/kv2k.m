function k = kv2k(V, dispersion)
% Returns the wavenumber k for a quasiparticle tunneling into Cu(111)
% where V is the voltage of the sample with respect to the tip. 
% Units: 1/Angstroms

c = kconstants;
if nargin<2 || isempty(dispersion), dispersion=[]; alpha=0; end
if length(dispersion) > 1   % this is actually a vector of [E0 mstar alpha]
    if length(dispersion) == 3, alpha = dispersion(3); end
    c.mstar = dispersion(2); c.m = c.mstar * c.me;
    c.E0 = dispersion(1);
end

energy = V + c.E0;

% Evaluate the inverse dispersion relation
if alpha == 0
    k = sqrt(energy/c.ec*(2*c.m)) / c.hbar*1e-10;
else
    b = c.hbar^2/(2*c.m)*10^20*c.ec;
    k = sqrt((-b + sqrt(b^2 + 4*alpha*energy))/(2*alpha));
end
