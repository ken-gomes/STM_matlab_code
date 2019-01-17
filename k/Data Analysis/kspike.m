function map_out=kspike(map, lim, d)

% map_out=kspike(map, d, lim)
% Removes the single spikes from the map
% d = 0 compares with all 4 neighbors
% d = 1 compares with neighbors in same columm (for scan along x) 
% d = 2 compares with neighbors in same line (for scan along y)
%

if nargin<2, lim=3*std2(map); end; %disp(lim); end; 
if nargin<3, d=2; end;
[d1, d2]=size(map);
map_out=map;

if d==0,
    for i=2:d1-1,
        for j=2:d2-1,
            if abs(map(i,j)-map(i+1,j))>lim && abs(map(i,j)-map(i,j+1))>lim &&...
                    abs(map(i,j)-map(i-1,j))>lim && abs(map(i,j)-map(i,j-1))>lim,
                map_out(i,j)=(map(i+1,j)+map(i-1,j)+map(i,j+1)+map(i,j-1))/4;
            end;
        end;
    end;
elseif d==1,
    for i=2:d1-1,
        for j=2:d2-1,
            if abs(map(i,j)-map(i+1,j))>lim && abs(map(i,j)-map(i-1,j))>lim, 
                map_out(i,j)=(map(i+1,j)+map(i-1,j))/2;
            end;
        end;
    end;
else
    for i=2:d1-1,
        for j=2:d2-1,
            if abs(map(i,j)-map(i,j+1))>lim && abs(map(i,j)-map(i,j-1))>lim,
                map_out(i,j)=(map(i,j+1)+map(i,j-1))/2;
            end;
        end;
    end;
end;
