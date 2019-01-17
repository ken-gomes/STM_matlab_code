function data=kgm(fname,bias,pd)

% data=kgm(fname,bias,pd)
% Produces a gapmap out of data matrix with poly fitting to the data
% Input: fname = data file from kopen
%        bias = enter setpoint bias or set 0 for STMmode bias (optional);
%        bias can also be a vector for the scale in the data.
%        pd = if pd<5, pd is the smoothing factor for the specs,
%             else it is the poly degree for fitting. 
%             if pd=0 no fitting or smoothing (default option) 
% Output: data = gapmap

% defining the bias and averaging data at same point
if nargin<3, pd=0; end;
if nargin<2,
    xd=fname{3}.xdata+fname{3}.bias;
else
    if length(bias)==1,
        xd=fname{3}.xdata+bias;
    else
        xd=bias;
    end;
end;
mainavg=kgmavg(fname);

% finding the zero bias point data
nz=1;
while xd(nz)<0
    nz=nz+1; 
end

% redefine data for positive bias
n1=fname{3}.xsz;
disp(n1-nz+1)
n2=size(mainavg,2);
mtx=mainavg(nz:n1,:);
x=xd(nz:n1)*100;
gm=zeros(1,n2);

% In case there are error messages on the fit turn the warnings off:
%warning off all

%finding max points and saving data as gapmap.
if pd==0,
    for i=1:n2,
        [p,m]=max(mtx(:,i));
        gm(1,i)=x(m);
    end;
else
    if pd<5,
        for i=1:n2,
            [p,m]=max(ksmooth(mtx(:,i),pd));
            gm(1,i)=x(m);
        end;
    else
        for i=1:n2,
            [p,S,mu] = polyfit(x',mtx(:,i),pd);
            fitdata = polyval(p,x,S,mu);
            [p,m]=max(fitdata);
            gm(1,i)=x(m);
        end;
    end;
end;

% writing result
data = reshape(gm,sqrt(n2),sqrt(n2));

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