function rgb_map=khsv(map, rflip, S)
% Generates a RGB image based on a HSV map. 
% The values of map are applied to color S, the H is a color wheel, and V is always 1. 
% At rflip, the direction of the wheel is fliped.

if nargin<2, rflip=0; end;

[n,m]=size(map);
map_hsv=ones(n,m,3);
cn=round((n+1)/2); cm=round((m+1)/2);

if nargin<3,
    for i=1:n,
        for j=1:m,
            r=sqrt((i-cn)^2+(j-cm)^2);
            if r<rflip,
                map_hsv(i,j,1)=-atan2(i-cn, j-cm);
            else
                map_hsv(i,j,1)=-atan2(cn-i, cm-j);
            end;
        end;
    end;
    map_hsv(:,:,1)=(map_hsv(:,:,1)+pi)/2/pi;
else
    ns=size(S,2);
    S=S+0.5;
    S(S>1)=S(S>1)-1;
    for i=1:n,
        for j=1:m,
            r=sqrt((i-cn)^2+(j-cm)^2);
            if r==0, 
                theta=1;
            else
                theta=round(atan2((cn-i),(cm-j))*ns/(2*pi)+ns/2+1); theta(theta==ns+1)=1;
            end;
            if r<rflip,
                map_hsv(i,j,1)=S(1,theta);
            else
                map_hsv(i,j,1)=S(2,theta);
            end;
        end;
    end;
end;

map_hsv(:,:,2)=map; map_hsv(:,:,3)=map_hsv(:,:,3)/max(max(map_hsv(:,:,3)));

rgb_map=hsv2rgb(map_hsv);

