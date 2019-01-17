function [data,xbias]=kgmsp(fname,nspec,gmin,bias)

% [data,xbias]=kgmsp(fname,nspec,gmin,bias)
% Produces several average specs based on gap size.
% Input: fname = data file from kopen
%        nspec =  number of specs
%        gmin = gapmap of the fname (optional)
%        bias = enter setpoint bias or set 0 for STMmode bias or vector with bias (optional)
% Output: data = specs
%         xdata = bias axis to plot specs (optional)  
% defining the bias and averaging data at same point
if nargin<4,
    xbias=fname{3}.xdata+fname{3}.bias;
else
    if length(bias)==1,
        xbias=fname{3}.xdata+bias;
    else
        xbias=bias;
    end;
end;

if nargin<3, gmin=kgm(fname); end;

%averaging the specs
mainavg=kgmavg(fname);

% define relevant variables
n1=fname{3}.xsz;
n2=size(mainavg,2);
gm=reshape(gmin,1,n2);
sp=zeros(n1,nspec);
spc=zeros(1,nspec);
maxv=max(gm);
minv=min(gm);

%finding max points and saving data as gapmap.
for i=1:n2,
    spi=ceil(nspec*((gm(1,i)-minv)/(maxv-minv)));
    if spi==0, spi=1; end;
    sp(:,spi)=sp(:,spi)+mainavg(:,i);
    spc(spi)=spc(spi)+1;
end;

data=zeros(n1,nspec);
for i=1:nspec,
    if spc(i)~=0,
        data(:,i)=sp(:,i)/spc(i);
    end;
end;

xbias=xbias'*100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data=kgmavg(fname)

% Average the data taken at same point for didv maps. 
% Input: fname = file where initial data is after kopen
% Outpot: out = average of data


n1=fname{3}.xsz;                       % # of energies
n2=fname{1}.xsz*fname{1}.ysz;    % # of pixels
n3=fname{3}.ysz/n2;                   % # of spec/pixels
mtx=fname{3}.main;

data=zeros(n1,n2);
for i=1:n1,
    for j=1:n2,
        for k=1:n3,
            data(i,j)=data(i,j)+mtx(i,(j-1)*n3+k)/n3;
        end;
    end;
end;

% end of file