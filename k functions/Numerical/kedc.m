function [A, e]=kedc(E,d,g1,g0,T,r, sym)

%[A, e]=kedc(E,d,g1,g0,T,r)
%Produces EDCs as seen with ARPES.
% out: A-EDC, e-energy axis
% in: E=energy range in mV. d=gap size(mV).
%     g1 and g0 = lifetime broadening. T = temperature. r=resolution.
%     sym = to tell to make a symmetric plot. 

if nargin==7,sym=1; else sym=0; end;
if nargin<6, r=1001; end;
if nargin<5, T=0; end;
if nargin<4, g0=0; end;
if nargin<3, g1=10; end;

dE=2*E/(r-1);
e=(-E:dE:E)';

sigma=-i*g1+d^2./(e+i*g0);
A=1/pi*(imag(1./(e-sigma)));
A=A/A(1);

T=T*0.08617;
if T~=0,
    fd=1./(exp(e/T)+1);
    A=A.*fd;
end;

if sym, A=A+flipud(A); end;
