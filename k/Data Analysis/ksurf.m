function ksurf(record,cm)
% function ksurf(record)
% makes a 3D surface plot of a LTSTM record
% Same as ltsurf but modified to my pleasure.

if ~isstruct(record)
    t=record;
    record=struct;
    record.Data = t;
end

% Normalize to [0,1];
record = ltnorm(record);
    
surf(record.Data,'LineStyle','none');
lighting phong;

axis off square tight;
set(gca,'Layer','top');

set(gca,'Units','normalized');

shading interp;
view([0,90]);

set(findobj(gca,'type','surface'), ...
    'FaceLighting',      'phong',  ...
    'AmbientStrength',   .2,        ...
    'DiffuseStrength',   1,        ...
    'SpecularStrength',  0.8,      ...
    'SpecularExponent',  40,       ...
    'BackFaceLighting',  'lit');
light;

if nargin==2,
    kcm(cm);
else
    kcm('gold');
end;