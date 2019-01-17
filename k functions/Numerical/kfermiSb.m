function [M, Ms1, Ms2] = kfermiSb(N, R, R1, R2, d)

%   [M, Ms1, Ms2] = kfermiSb(N, R, R1, R2, d)
%   Generates 6 fermi surface pockets with with radius R1,
%   R2 pixels from the center. 
%   N is the resolution of the image.
%   the outputs are the pure image M and the spin components Ms1 and Ms2.
%   Use kconv(M)+kconv(Ms1)+kconv(Ms2) to generate the spin selected FFTs.

% Building the hole and electron pockets
FS=poket(N, R1, R2);
FSc=kfermic(N,R);

% Making the 6 hole pockets around the center
M=ktranslate(FS,[0,d])+fliplr(ktranslate(FS,[0,d]));%ktranslate((FS),[0,-d]);
M=M+imrotate(M,60, 'crop')+imrotate(M,120, 'crop');

% Creating the spin resolved versions of the pockets
[S1, S2]=kspin(N,1,floor(N/2));
Ms1=FSc.*S1-M.*S1;
Ms2=FSc.*S2-M.*S2;
M=M+FSc;


function out=poket(N,R1, R2)
% generates the triangular shaped fermi surface

out=zeros(N);
nr=max(size(R1));
c=(N+1)/2;
for ni=1:nr,
    for i=-R1(ni):-R1(ni)+5,
        out(c+round(sqrt(R1(ni)^2-i^2)*R2/R1(ni)),c+i)=1;
        out(c-round(sqrt(R1(ni)^2-i^2)*R2/R1(ni)),c+i)=1;
    end;
end;
