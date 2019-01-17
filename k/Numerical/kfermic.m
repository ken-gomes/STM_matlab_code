function [out] = kfermic(N, R, C, NC)

% [out] = kfermic(N, R, C, NC)
% Generates a circular fermi surface image
% N pixels 
% R radius (if R is vector it draws co-centric circles).
% C (optional) translates the center of the circle 
% NC is the number of symmetrical circles.

out=zeros(N);
nr=max(size(R));
c=(N+1)/2;
for ni=1:nr,
    for i=-R(ni):R(ni),
        out(c+i,c+round(sqrt(R(ni)^2-i^2)))=1;
        out(c+i,c-round(sqrt(R(ni)^2-i^2)))=1;
    end;
end;

% trying to make is more circular, reducing the effect of square pixels...
%out=ksmooth(klim(out+rot90(out),0,1),2);
%out=out+rot90(out);
%out=ksmooth(klim(out+imrotate(out,45,'bilinear','crop'),0,1));
out=ksym(ksmooth(out),12); out=out./max(out(:)); %out(out>0)=1;

if nargin>2,
    out=ktranslate(out,[C(1), C(2)]);
end;

if nargin>3,
    m1=out+rot90(out,2);
    out=m1;
    for i=1:NC/2-1,
        out=out+imrotate(m1,i*360/NC,'bilinear','crop');
    end;
end;