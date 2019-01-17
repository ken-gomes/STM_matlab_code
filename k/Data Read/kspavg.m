function data=kspavg(fname,ns)

% Average spec files.
% Input: fname = file where initial data is after kopen or matrix with
%   specs
% Outpot: data = matrix with avg for data on every point.

if isa(fname, 'cell'),                   
    data=mean(fname{1}.main,2);   
elseif isa(fname, 'double'),
    data=mean(fname,2);
end

if nargin>1, 
    data=ksmooth(data,ns);
end;

%end of file