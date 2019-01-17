function [M, Ms1, Ms2] = kfermig(N, R1, R2)

%   [M, Ms1, Ms2] = kfermi6(N, R1, R2)
%   Generates 6 fermi surface pockets with with radius R1,
%   R2 pixels from the center. 
%   N is the resolution of the image.
%   the outputs are the pure image M and the spin components Ms1 and Ms2.
%   Use kconv(M)+kconv(Ms1)+kconv(Ms2) to generate the spin selected FFTs.

% Choose the shape of the fermi surface kfermic for circular and tpocket
% for triangular shaped.
%FS=tpoket(N,R1);
FS=kfermic(N,R1);

[S1, S2]=kspin(N,2,R1(end)+20);
FSs1=FS.*S1;
FSs2=FS.*S2;
M=ktranslate(FS,[0,R2])+ktranslate(fliplr(FS),[0,-R2])...
    +ktranslate(fliplr(FS),[round(sqrt(3)*R2/2),round(R2/2)])+...
    +ktranslate(FS,[round(sqrt(3)*R2/2),-round(R2/2)])+...
    +ktranslate(fliplr(FS),[-round(sqrt(3)*R2/2),round(R2/2)])+...
    +ktranslate(FS,[-round(sqrt(3)*R2/2),-round(R2/2)]);
Ms1=ktranslate(FSs1,[0,R2])+ktranslate(fliplr(FSs1),[0,-R2])...
    +ktranslate(fliplr(FSs1),[round(sqrt(3)*R2/2),round(R2/2)])+...
    +ktranslate(FSs1,[round(sqrt(3)*R2/2),-round(R2/2)])+...
    +ktranslate(fliplr(FSs1),[-round(sqrt(3)*R2/2),round(R2/2)])+...
    +ktranslate(FSs1,[-round(sqrt(3)*R2/2),-round(R2/2)]);
Ms2=ktranslate(FSs2,[0,R2])+ktranslate(-fliplr(FSs2),[0,-R2])...
    +ktranslate(-fliplr(FSs2),[round(sqrt(3)*R2/2),round(R2/2)])+...
    +ktranslate(FSs2,[round(sqrt(3)*R2/2),-round(R2/2)])+...
    +ktranslate(-fliplr(FSs2),[-round(sqrt(3)*R2/2),round(R2/2)])+...
    +ktranslate(FSs2,[-round(sqrt(3)*R2/2),-round(R2/2)]);

function FS=tpoket(N,R)
% generates the triangular shaped fermi surface

FS=zeros(N);
nr=max(size(R));
c=(N+1)/2;
for ni=1:nr,
    for i=-round(R(ni)*sqrt(3)/2):round(R(ni)*sqrt(3)/2),
        FS(c+i,c-round(R(ni)/2))=1;
    end;
     for i=0:round(3*R(ni)/2),
         FS(c+round(i/sqrt(3)),c-i+R(ni))=1;
         FS(c-round(i/sqrt(3)),c-i+R(ni))=1;
     end;
end;
FS=ksmooth(FS);
