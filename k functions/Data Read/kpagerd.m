function data=kpagerd(fid, header, fname)

% Modified version of mvpagerd made to work on mac.
% subfuntion used inside kopen.

[b, locs]=tokenize(cat(2,char(header')));

%define parameters
data.fname		=fname;
data.date		=b(3,:);
data.time		=b(4,:);
data.type		=str2double(b(5,:));
data.data_type	=str2double(b(6,:));
data.sub_type	=str2double(b(7,:));
data.xsz        =str2double(b(8,:));
data.ysz        =str2double(b(9,:));
data.page_type  =str2double(b(11,:));

n=locs(1);
data.xscale		=str2double(b(n+1,:));	%'X'
data.xoffset	=str2double(b(n+2,:));

m=locs(2);
data.yscale		=str2double(b(m+1,:));	%'Y'
data.yoffset	=str2double(b(m+2,:));

o=locs(3);
data.zscale		=str2double(b(o+1,:));	%'Z'
data.zoffset	=str2double(b(o+2,:));

p=locs(4);
data.xyscale	=str2double(b(p+1,:));	%'XY'
data.angle 		=str2double(b(p+3,:));
data.xunits=' ';
data.yunits=' ';
data.zunits=' ';
if (m-n) == 4, data.xunits=b(n+3,:);	end;
if (o-m) == 4, data.yunits=b(m+3,:);	end;
if (p-o) == 4, data.zunits=b(o+3,:);	end;

q=locs(5);
data.current	=str2double(b(q+1,:));	%'IV'
data.bias		=str2double(b(q+2,:));

r=locs(6);
data.scandir	=str2double(b(r+1,:));	%'scan'
data.scanper	=str2double(b(r+2,:));
data.label		=b(r+6,:);
data.comment	=b(r+7,:);

%read data and make info for user
if (data.type==0),
	data.main=data.zscale*read_in(fid, data.xsz, data.ysz, data.data_type);
else
	data.main=data.zscale*read_in(fid, data.xsz, data.ysz, data.data_type);
end;
data.xdata=(1:size(data.main,1))*data.xscale+data.xoffset; 
data.ydata=(1:size(data.main,2))*data.yscale+data.yoffset;               

switch data.type,
  case 3,
    tmp=fread(fid,[8,data.ysz],'float');
    data.places=tmp(3:4,:);
end;

function d=read_in(fid, xsz, ysz, data_type)
    switch data_type,
  		case 0, d=fread(fid,[xsz,ysz],'float32'); 
  		case 1, d=fread(fid,[xsz,ysz],'int16', 'ieee-le');
  		case 2, d=fread(fid,[xsz,ysz],'int32', 'ieee-le'); 
  		case 3, d=fread(fid,[xsz,ysz],'int8', 'ieee-le'); 
    end;