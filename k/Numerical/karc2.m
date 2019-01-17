function [DOS, e, delta]=karc2(E,d1,d2,B,gamma,T,r,ntau)
% [DOS, e]=karc2(E,d1,d2,th,g,T,r,ntau)
% builds the arc DOS for given delta and gamma and Temperature
% Input: E = range of energies
%        d = delta
%        g = gamma (optional)
%        T = temperature (optional)
%        r = number of data points on plot. (optional)
%        th = angle where arc starts.
%        ntau=resolution in angle
% Outpot:DOS = result.
%        e = energy range for plotting.

if nargin<8,ntau=2500; end; 
if nargin<7, r=1001; end;
if nargin<6, T=0; end;
if nargin<5, gamma=1; end;
if nargin<4, B=0.5; end;

tau=(0:pi/4/ntau:pi/4);
DOS=zeros(r,1);
dE=2*E/(r-1);
e=(-E:dE:E)';
g=abs(-gamma:2*gamma/(r-1):gamma);

% Defining gaps
%delta2=d2*(B*cos(2*tau)+(1-B)*cos(6*tau));
delta2=d2*cos(2*tau/B);
delta1=d1*cos(2*tau);

% Setting the arc
delta=max(delta1,delta2);

% Calculating DOS with optional thermal broadening
for j=1:r,
    f1= abs(real((e(j)-g(j)*i)./sqrt((e(j)-g(j)*i)^2-(delta).^2)));
    DOS(j)=sum(f1);
end;
% Calculating DOS with optional thermal broadening
if T~=0,DOS=ktb(DOS,E,T);end;

%Normalizing DOS
DOS=DOS/sum(DOS)*size(DOS,1);
