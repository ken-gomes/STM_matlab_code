function [DOS, e]=kvspec(E,d,g,T,r,B)
% builds the d-wave DOS for given delta and gamma and Temperature
% Input: E = range of energies
%        d = delta
%        g = gamma (optional)
%        T = temperature (optional)
%        r = number of data points on plot. (optional)
%        B = how much weight on the second harmonics. 1 is pure d-wave.
% Outpot:D = result.
%        e = energy range for plotting.

if nargin<6, B=1; end;
if nargin<5, r=1001; end;
if nargin<4, T=0; end;
if nargin<3, g=1; end;

tau=0:pi/4/2500:pi/4;
DOS=zeros(r,1);
dE=2*E/(r-1);
e=(-E:dE:E)';
voff=0;

% Defining delta with optional second harmonics
if B==1, 
    delta=d*cos(2*tau);
else
    delta=d*(B*cos(2*tau)+(1-B)*cos(6*tau));
end;

% Calculating DOS with optional thermal broadening
for j=1:r,
    normv=fvspec(e(j),tau,delta,voff);
    f1= abs(real((e(j)-g*i).*normv./sqrt((e(j)-g*i)^2-(delta).^2)));
    DOS(j)=sum(f1);
end;

% Calculating DOS with optional thermal broadening
if T~=0,DOS=ktb(DOS,E,T);end;

%Normalizing DOS
DOS=DOS/sum(DOS)*size(DOS,1);
%plot(e,DOS);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function normv=fvspec(e,tau,delta,voff)

tau0=30*pi/180;
ntau=size(tau,2)-1;
normv=sqrt(e^2-delta.^2+voff^2);
normv(round(ntau-4*ntau*tau0/pi)+1:ntau+1)=150;%normv(round(ntau-4*ntau*tau0/pi));