function [fit,d,g,lc]=kdfit(ds,dn,dmax,T,n,E)

% finds the best fit for ds, using kdw result times the normal state dn.
% Input: ds= superconducting DOS
%        dn= normal state DOS
%        dmax= max value of delta to probe.
%        T = temperature (optional).
%        n = energy bin to find delta (optional).
%        E = max energy for plot of DOS(optional).
% Outpot:fit= d-wave wave fit.
%        d = value of delta.
%        g = value for gamma.
%        lc= difference between plots.

if nargin<6, E=200; end;
if nargin<5, n=2; end;
if nargin<4, T=0; end;
r=size(ds,1);
dmax=round(dmax/n);
f=kdw(E,0,1,T,r);
lc=norm(ds-(f.*dn));d=0;g=2;fit=f;
for di=1:dmax,
    for gi=1:di,
        f=kdw(E,di*n,gi*n,T,r);
%        c=sum(abs(ds-(f.*dn)));
        c=norm(ds-(f.*dn));
        if c<lc,
            d=di*n; g=gi*n; fit=f;lc=c;
        end;
    end;
end;
