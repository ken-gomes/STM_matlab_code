function data=kopen
%Reads multiple SM2 files using kread

filter = {'*.sm2;*.sm3;*.SM3;*.SM2','RHK Data Files';'*.*',  'All Files (*.*)'};
[files, fpath] = uigetfile(filter, 'Read STM data from...','Multiselect','on');

if isequal(files,0), 
    disp('User selected Cancel')
data=0;
else
    if iscellstr(files)
        data=cell(1,size(files, 2));
        for i=1:size(files, 2)
            filename = cat(2, fpath, char(files(i)));
            data{i}=kread(filename);
        end;
    else
        filename = cat(2, fpath, char(files));
        data=kread(filename);
    end;
end;
