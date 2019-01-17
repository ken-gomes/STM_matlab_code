function data=kread(fname)
% This is a modified version of mvimrd. You should call kopen instead.
% This function uses kpagerd
% The avarage stuff was cripped out for being buggy. Use kspavg function.
% Returns a cell containing all data and header information.

fid=fopen(fname,'r','ieee-le');

%Just save the file name if a full path was used.
remainder = fname;
while (any(remainder))
  [chopped,remainder] = strtok(remainder,'/\\'); %#ok<STTOK>
  fname = chopped;
end

data={};
d=cell(1);

%Need to determine if it is an SM2 or SM3 file here. Have to use the header
fieldSize = fread(fid, 1, 'int16');
signature = fread(fid, 18, 'int16=>char');
[token, remain] = strtok(signature');
version = strtok(remain);

if(~isempty(strfind(token,'STiMage'))) %Should be an SM3 file

    %Do a version check as this code assumes version 4.002 currently
    %by assuming that the field size is 170.
    version = str2double(version);
    if(version > 4.002)
        disp('SM3 file version newer than 4.002. Some bugs may occur.')
    end;
    
    %Loop through pages in the file
    while (~feof(fid) && fieldSize == 170)
        %Read in the rest of the file. Substract size of signature from the
        %number of bytes left to be read in from the header.
        d{1}=kpagerdSM3(fid, fieldSize-36, fname);
        data=cat(2,data,d);
        fieldSize = fread(fid, 1, 'int16');
        fread(fid, 18, 'int16=>char');
    end;
    
    %Error checking. Should always be 170 bytes for version 4.002.
    if(fieldSize ~= 170)
        error('Bad read from file. Expected beginning of next page header.')
    end;
    
    %Reordering the pages, following SM2;
    if size(data,2)>2,
        tp=1;sp=3;
        for i=1:size(data,2),
            if data{i}.page_type==1 && mean(data{i}.label=='T')*10==1, 
                dt=data{i};
                data{i}=data{tp};
                data{tp}=dt;
                tp=tp+1;
            end;
            if data{i}.type==1 && sp==3,
                dt=data{i};
                data{i}=data{sp};
                data{tp}=dt;
                sp=sp+1;
            end;
        end;
    end;
    
    
else %Probably an sm2 file. Reset read position to beginning of file
    
    fseek(fid, 0, 'bof');
    
    %read header as a block
    header=fread(fid,512,'char'); sz=size(header); 

    %read pages in
    while (sz(2)==1),
        d{1}=kpagerd(fid, header, fname);
        data=cat(2,data,d);
        header=fread(fid,512,'char'); sz=size(header); 
    end;
end;

fclose(fid);