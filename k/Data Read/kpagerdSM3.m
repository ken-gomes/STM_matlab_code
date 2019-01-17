function data=kpagerdSM3(fid, togo, fname)
%Read the page data from an already open SM3 file.
%Fields field size and signature should already have been read in.

data.fname = fname;

%Used later for number of text strings in the file
stringCount = fread(fid, 1, '*int16');
togo = togo - 2;

data.type = fread(fid, 1, '*int32');
togo = togo - 4;

data.page_type = fread(fid, 1, '*int32');
togo = togo - 4;

data.dataSubSource = fread(fid, 1, '*int32');
togo = togo - 4;

data.line_type = fread(fid, 1, '*int32');
togo = togo - 4;

%Read in x, y corner and width and height info
data.xCorner = fread(fid, 1, 'int32');
data.yCorner = fread(fid, 1, 'int32');
data.xsz = fread(fid, 1, 'int32');
data.ysz = fread(fid, 1, 'int32');
togo = togo - 16;

data.source_type = fread(fid, 1, '*int32');
togo = togo - 4;

data.image_type = fread(fid, 1, '*int32');
togo = togo - 4;

data.scan = fread(fid, 1, '*int32');
togo = togo - 4;

data.groupID = fread(fid, 1, '*int32');
togo = togo - 4;

data.page_size = fread(fid, 1, '*uint32'); %size in bytes of the data section
togo = togo - 4;

data.minZ = fread(fid, 1, '*uint32');
togo = togo - 4;

data.maxZ = fread(fid, 1, '*uint32');
togo = togo - 4;

scale = fread(fid, 3, 'float32')'; %X, Y, Z scale.Expects a horizontal array.
data.xscale = scale(1);
data.yscale = scale(2);
data.zscale = scale(3);

togo = togo - 12;

data.xyscale = fread(fid, 1, 'float32');
togo = togo - 4;

offset = fread(fid, 3, 'float32')'; %X, Y, Z offsets. Expects a horizontal array.
data.xoffset = offset(1);
data.yoffset = offset(2);
data.zoffset = offset(3);
togo = togo - 12;

data.period = fread(fid, 1, 'float32');
togo = togo - 4;

data.bias = fread(fid, 1, 'float32');
togo = togo - 4;

data.current = fread(fid, 1, 'float32');
togo = togo - 4;

data.angle = fread(fid, 1, 'float32');
togo = togo - 4;

data.pageID = fread(fid, 16, 'int8'); %this is not the right format, but right size
togo = togo - 16;

colorInfoCount = fread(fid, 1, '*int32');
togo = togo - 4;

data.gridXSize = fread(fid, 1, '*int32'); %used for spectral maps
togo = togo - 4;

data.gridYSize = fread(fid, 1, '*int32');
togo = togo - 4;

if togo~=0,
    disp('Different number of  bytes in header than expected. Remaining %d.', togo);
    %Try to move the file position indicator ahead. Likely would cause more
    %problems than it would solve.
    fseek(fid, togo, 0);
end

%Read in string information. These should be the first fields after what
%is defined to be the header.
for i=1:stringCount
    sz = fread(fid, 1, 'int16');
    str = fread(fid, sz, 'int16=>char')';
    switch i
        case 1
            data.label = str;
        case 2
            data.systemText = str;
        case 3
            data.comment = str;
        case 4
            data.userText = str;
        case 5
            data.path = str;
        case 6
            data.date = str;
        case 7
            data.time = str;
        case 8
            data.xUnits = str;
        case 9
            data.yUnits = str;
        case 10
            data.zUnits = str;
        case 11
            data.xLabel = str;
        case 12
            data.yLabel = str;
        case 13
            data.extras = str; %in case there is more...
    end %switch
end %for i=1:stringCount

%Emulate old SM2 "data_type" field and read in the data array
if(isfloattype(data.line_type))
    data.data_type = 0;
    if(data.page_type == 36 || data.page_type == 37) %Discrete Spectroscopy has an extra line for the voltages
        data.CITS_voltages = data.xscale*fread(fid, double(data.xsz), 'float32');
    end
    data.main = fread(fid, double([data.xsz, data.ysz]), 'float32');
else
    data.data_type = 2;
    data.main = fread(fid, double([data.xsz, data.ysz]), 'int32');
end
data.main = data.zscale*data.main+data.zoffset;
data.xdata=(1:size(data.main,1))*data.xscale+data.xoffset; 
data.ydata=(1:size(data.main,2))*data.yscale+data.yoffset;

%Spectra locations
if(data.type == 3 || (data.type == 1 && (data.page_type == 16 || data.page_type == 37 || data.page_type == 38 || data.page_type == 39)))
    data.places(1, :) = fread(fid, double(data.ysz), 'float32'); %X locations
    data.places(2, :) = fread(fid, double(data.ysz), 'float32'); %Y locations
end

%Color info section - just skipping it.
if(data.type == 0 && data.page_type >= 1 && data.page_type <= 5) %i.e. image
    sz = fread(fid, 1, 'int16');
    fseek(fid, sz*colorInfoCount, 0);
end


%%%%%%%%%%%%%%%%%%%%%

function output=isfloattype(line_type)
%Determine whether the given lineType is a floating point
%data type or not

%assume it's not floating point
switch(line_type)
    case {6,9,10,11,13,14,18,19,21,22}
        output = true;
    otherwise
        output = false;
end %switch