function fbroad=ktb(f,E,T,T2)
% fbroad=ktb(f,E,T,T2)
%
% outputs a thermally broadened version of the original function.
% input: f - original function
%        E - Energy range of the plot, in mV.
%        T - Temperature
%        T2 - Broadens the curve from T to T2.

if nargin==4,
    if T2>T,
        T=sqrt(T2^2-T^2);
    else
        T=-sqrt(T^2-T2^2);
    end
end

T=T*0.08617;
r=length(f);
if isscalar(E),
    E=-E:2*E/(r-1):E;
end

if T>0,
    fbroad=bk(E,T,r)*f;
else
    fbroad=inv(bk(E,-T,r))*f;
end

    
function fbk=bk(E,T,nE)

fbk=zeros(nE);

for i=1:nE,
    for j=1:nE;
        fbk(i,j)=exp((E(i)-E(j))/T)/(exp((E(i)-E(j))/T)+1)^2;
    end;
    fbk(i,:)=fbk(i,:)/sum(fbk(i,:));
end;






    