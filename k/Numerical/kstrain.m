function svp =kstrain(vp,strain, type)
% svp =kstrain(vp,strain, type)
% vp should contain a [n,2] matrix with the coordenates of n CO atoms.
% strain = magnitude of the strain. it is applied for each type of strain.
% type follow the table below:
% type=1 - strain along 3 directions as strain*R^2cos(3theta).
% type=2 - strain along one direction as 
% type=3 - pn junction

if nargin<3, type=1; end;
svp=vp;

%type 1 strain: constant field
if type==1,
    svp(:,1)= vp(:,1)+2*strain*vp(:,1).*vp(:,2);
    svp(:,2)= vp(:,2)+strain*(vp(:,1).^2-vp(:,2).^2);
end;

% type 2 strain
if type ==2,
    for i=1:size(vp,1),
        svp(i,1)=vp(i,1)*(1+strain);
        svp(i,2)=vp(i,2)/(1+strain);
        %svp(i,1)=vp(i,1)/(1+strain);
    end;
end;

% type 3 strain
if type ==3,
    for i=1:size(vp,1),
%        if sign(vp(i,1))>0,
        svp(i,1)=vp(i,1)*(1+strain*sign(vp(i,1)));% end;
        %svp(i,2)=vp(i,2)*(1+strain*sign(vp(i,1)));
    end;
end;

if type==4,
    for i=1:size(vp,1),
        if (vp(i,1)~=0 || vp(i,2)~=0),
            r=sqrt(vp(i,1)^2+vp(i,2)^2);
            ct=vp(i,1)/r; st=vp(i,2)/r;
            svp(i,1)=vp(i,1)+sign(vp(i,1))*strain*(r)^2*((3*st-4*st^3)*ct-(4*ct^3-3*ct)*st);
            svp(i,2)=vp(i,2)+sign(vp(i,1))*strain*(r)^2*((3*st-4*st^3)*st+(4*ct^3-3*ct)*ct);
        end
    end;
end;

