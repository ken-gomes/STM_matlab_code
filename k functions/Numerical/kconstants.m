function constants = kconstants

constants.E0 = 0.45;   % Band edge for surface state electrons on Cu(111) (eV) -- This is E_F - E_edge (positive number)
constants.ec = 1.60217646e-19;  % electron charge (C)
constants.hbar  = 6.58202e-16; % Planck's constant (eV s)

constants.me = 9.10938188e-31;  % electron mass (kg)
constants.mstar = 0.38;     % effective mass for Cu(111) surface state electrons (me)
constants.m = constants.mstar * constants.me;  % effective mass for Cu(111) surface state electrons (kg)

constants.a = 2.54772; % lattice constant of Cu(111) at 4K -- it is 2.55625 at 298K
