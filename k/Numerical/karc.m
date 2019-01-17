function [DOS, e, delta]=karc(E,d,th,g,T,r,ntau)
% [DOS, e]=karc(E,d,th,g,T,r,ntau)
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

if nargin<7,ntau=2500; end; 
if nargin<6, r=1001; end;
if nargin<5, T=0; end;
if nargin<4, g=1; end;
if nargin<3, th=18; end;

tau=0:pi/4/ntau:pi/4;
DOS=zeros(r,1);
dE=2*E/(r-1);
e=(-E:dE:E)';
%th=th*pi/180;

% Defining the arc with second harmonic.
delta=d*(th*cos(2*tau)+(1-th)*cos(6*tau));
delta(delta<0)=0;

% Defining the arc with the given angle.
%delta=d*cos(pi/2*(1-(tau-pi/4+th)/(pi/4-th)));
% Setting the arc
%delta(round(ntau-4*ntau*th/pi)+1:ntau+1)=0;


% Calculating DOS with optional thermal broadening
for j=1:r,
    f1= abs(real((e(j)-g*i)./sqrt((e(j)-g*i)^2-(delta).^2)));
    DOS(j)=sum(f1);
end;
if T~=0,DOS=ktb(DOS,E,T);end;

DOS=DOS/sum(DOS)*size(DOS,1);
%plot(e,DOS);axis([min(e) max(e) 0 1.5]);