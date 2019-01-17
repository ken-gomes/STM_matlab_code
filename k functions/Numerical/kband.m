function [Es, En, k, gymg, En2, gymg2]=kband(delta,mu,gamma)

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

if nargin<3, gamma=0; end;
if nargin<2, mu=1; end;

%Defing k space
nk=3000;
k=(-pi:2*pi/(nk-1):pi)';

% These are Jacob parameters (in mV)
%t0=148.799; t1=1;t2=-0.2749; t3=0.0872; t4=0.0938; t5=-0.0857; tmu=0.8772;

%These are Ali's parameters (in V):
t0=1000; t1=0.4;t2=-0.09; t3=0.045; t4=0; t5=0;tmu=0.43;

%Defining En
ng=nk/2;
En=zeros(nk);
En2{1}=En;
En2{2}=En;
for i=1:ng,
    for j=1:i,
        En(i,j) = t0*(-2*t1*(cos(k(i))+cos(k(j)))-...
            4*t2*cos(k(i))*cos(k(j))-...
            2*t3*(cos(2*k(i))+cos(2*k(j)))-...
            4*t4*(cos(2*k(i))*cos(k(j))+cos(k(i))*cos(2*k(j)))-...
            4*t5*cos(2*k(i))*cos(2*k(j))+tmu*mu);
        En(j,i)=En(i,j);
        En2{1}(i,j)=En(i,j)+(82/4)*(cos(k(i))-cos(k(j)))^2;
        En2{1}(j,i)=En2{1}(i,j);
        En2{2}(i,j)=En(i,j)-(82/4)*(cos(k(i))-cos(k(j)))^2;
        En2{2}(j,i)=En2{2}(i,j);
    end;
end;
En=rotcomp(En(1:ng,1:ng));
En2{1}=rotcomp(En2{1}(1:ng,1:ng));
En2{2}=rotcomp(En2{2}(1:ng,1:ng));

%Defining Es
if delta==0,
    Es=En; 
else
    Es=zeros(nk);
    for i=1:ng,
        for j=1:i,
            Es(i,j) = ((En(i,j)^2-gamma^2+(delta/4*(cos(k(i))-cos(k(j)))^2)^2+...
                (2*En(i,j)*gamma)^2)^(1/4)*cos(0.5*atan((-2*En(i,j)*gamma)/...
                (En(i,j)^2 + delta^2*(0.5*(cos(k(i))-cos(k(j))))^2-gamma^2))));
            Es(j,i)=Es(i,j);
        end;
    end;
    Es=rotcomp(Es(1:ng,1:ng));
end;

%Doing the cut along gamma-Y-M-gamma

gymg=gymgcut(En);
gymg2(:,1)=gymgcut(En2{1});
gymg2(:,2)=gymgcut(En2{2});

function Eout=rotcomp(Ein)
n=size(Ein);
Eout=Ein;
Eout(1:n,n+1:2*n)=rot90(Ein,3);
Eout(n+1:2*n,n+1:2*n)=rot90(Ein,2);
Eout(n+1:2*n,1:n)=rot90(Ein,1);

function cut=gymgcut(E)
n=size(E,1)/2;
gy=zeros(n,1);
for i=n+1:2*n,
    gy(i-n)=E(i,i);
end;
cut=interp1((1:n)',gy,(1:1/sqrt(2):n)');
n2=size(cut);
cut(n2+1:n2+n)=E(1:n,1);
cut(n2+n+1:n2+2*n)=E(n,1:n);
