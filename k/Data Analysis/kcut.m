function [data,x]=kcut(mtx,p1,p2,np)

% generates line cut on a given matrix, 
% Input: mtx = matrix map
%           p1= initial point in [x1 y1] format
%           p2= final point in [x2 y2] format
% Outpot: data = linecut;
%             x = x-data for linecut plot in the same units as the pixels;

x1=p1(1);
x2=p2(1);
y1=p1(2);
y2=p2(2);
nx=abs(x1-x2);
ny=abs(y1-y2);

if nx>ny
    data=zeros(1,nx+1);
    x=zeros(1,nx+1);
    if x1<x2
        if y1<y2
            for i=0:nx,
                r=i*ny/nx;
                j=floor(r);
                data(1,i+1)=(r-j)*mtx(y1+j,x1+i)+(j+1-r)*mtx(y1+(j+1),x1+i);
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        else
            for i=0:nx,
                r=i*ny/nx;
                j=floor(r);
                data(i+1)=(r-j)*mtx(y1-j,x1+i)+(j+1-r)*mtx(y1-(j+1),x1+i);
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        end;
    else
        if y1<y2
            for i=0:nx,
                r=i*ny/nx;
                j=floor(r);
                data(i+1)=(r-j)*mtx(y1+j,x1-i)+(j+1-r)*mtx(y1+(j+1),x1-i);
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        else
            for i=0:nx,
                r=i*ny/nx;
                j=floor(r);
                data(i+1)=(r-j)*mtx(y1-j,x1-i)+(j+1-r)*mtx(y1-(j+1),x1-i);
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        end;
    end;
else
    data=zeros(1,ny+1);
    x=zeros(1,nx+1);
    if x1<x2
        if y1<y2
            for i=0:ny,
                r=i*nx/ny;
                j=floor(r);
                data(i+1)=(r-j)*mtx(y1+i,x1+j)+(j+1-r)*mtx(y1+i,x1+(j+1));
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        else
            for i=0:ny,
                r=i*nx/ny;
                j=floor(r);
                data(i+1)=(r-j)*mtx(y1-i,x1+j)+(j+1-r)*mtx(y1-i,x1+(j+1));
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        end;
    else
        if y1<y2
            for i=0:ny,
                r=i*nx/ny;
                j=floor(r);
                data(i+1)=(r-j)*mtx(y1+i,x1-j)+(j+1-r)*mtx(y1+i,x1-(j+1));
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        else
            for i=0:ny,
                r=i*nx/ny;
                j=floor(r);
                data(i+1)=(r-j)*mtx(y1-i,x1-j)+(j+1-r)*mtx(y1-i,x1-(j+1));
                x(1,i+1)=sqrt(i^2+r^2);
            end;
        end;
    end;
end;

if nargin==4,
    xn=x(1):(x(end)-x(1))/(np-1):x(end);
    data=interp1(x,data,xn,'spline');
    x=xn;
end;
%end of file