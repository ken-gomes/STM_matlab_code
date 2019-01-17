function [DOS, e]=ksw(E,d,g,T,r)
% builds the d-wave DOS for given delta and gamma and Temperature
% Input: E = range of energies
%        d = delta
%        g = gamma (optional)
%        T = temperature (optional)
%        r = number of data points on plot. (optional)
% Outpot:D = result.
%        e = energy range for plotting.

if nargin<5, r=1001; end;
if nargin<4, T=0; end;
if nargin<3, g=1; end;

DOS=zeros(r,1);
dE=2*E/(r-1);
e=(-E:dE:E)';
for j=1:r,
    f1= abs(real((e(j)-g*i)./sqrt((e(j)-g*i)^2-(d).^2)));
    DOS(j)=sum(f1);
end;
if T~=0,
    DOS=ktb(DOS,E,T);
end;

DOS=DOS/sum(DOS)*size(DOS,1);
%plot(e,DOS);