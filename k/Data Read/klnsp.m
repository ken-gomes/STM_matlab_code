function data=klnsp(lnct,xbias,n)

[npoint, nspec]=size(lnct);
maxv=xbias(npoint);
sp=zeros(npoint,n);
spc=zeros(1,nspec);
lcgm=zeros(1,nspec);

nz=1;
while xbias(nz)<0
    nz=nz+1; 
end

ln1=lnct(nz:npoint,:);

for i=1:nspec,
    [p,m]=max(ln1(:,i));
    lcgm(1,i)=xbias(m+nz-1);
end;

for i=1:nspec,
    spi=ceil(n*lcgm(1,i)/maxv/1.005);
    if spi==0, spi=1; end;
    sp(:,spi)=sp(:,spi)+lnct(:,i);
    spc(spi)=spc(spi)+1;
end;

data=zeros(npoint,n);
for i=1:nspec,
    if spc(i)~=0,
        data(:,i)=sp(:,i)/spc(i);
    end;
end;