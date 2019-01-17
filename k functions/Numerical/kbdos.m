function [dos,E]=kbdos(band,E,nE,T)

%This sets up the Band structure as measured by ARPES.
%En gives the normal state energy of the wave vector (k(i),k(j)) 
%for a sample with doping mu. 
%Not exactly sure what the units are. mu=1 is optimal doping and it looks
%like mu=1.2 is well-overdoped and mu=0.4 or so is well-underdoped.
%
%Es gives the quasi-particle excitation energy for wave vector (k(i),k(j)) for
%a sample with doping mu with a gap  delta and with broadening gamma.
%
%Everything is measured in mV---that is, Ee, En, delta, gamma...
% 
%u and v are u^2 and v^2 even though their names don't reflect this. 
%
%DEn and DEe are the partial derivatives used for taking the gradient later.

if nargin<4, T=0; end;
if nargin<3, nE=100; end;
if isscalar(E),
    E=(-E:2*E/(nE-1):E)';
else
    nE=length(E);
end;

dos=zeros(nE,1);
nb=size(band,1);
nb=round(nb/2);
band=band(1:nb,1:nb);


%defining the gradient to be used later
[dEx, dEy]=gradient(band);
dband=sqrt(dEx.^2+dEy.^2);

%finding the contours of constant Energies
cband=contourc(band,E);
i=1;j=1;
while j<nE+1,
    np=cband(2,i);
    for k=1:np,
        dos(j)=dos(j)+1/dband(round(cband(1,i+k)),round(cband(2,i+k)));
    end;
    dos(j)=dos(j)/np;
    i=i+np+1;
    j=j+1;
end;

%funny normalization
%dos=dos/sum(dos)*nE;

%temperature broadening
if T~=0,
    dos=ktb(dos,E,T);
end;
