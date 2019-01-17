function cmap = kcm(map_name, map_length)
%   cmap = kcm(map_name, map_length) 
%   Creates matrix for some custom colormaps.
%   To change the current colormap you can just call
%   kcm(map_name, map_length);
%   by default map_length = 256;
%   Colormap names: 


if nargin < 2, map_length = 256; end;

switch map_name
    
    case 'bleu'
        map = colormap_via([0 0 0; 0 0 .5; .4 .5 .7; 1 1 1]);
        
    case 'bb'
        map = colormap_via([0 0 0; .5 .25 0; 0 .5 1; 0 1 1; 1 1 1]);
        
    case 'bwr'
        map = colormap_via([0 0 .4; 0 0 1; .4 .5 .7; 1 1 1; 1 1 1; .7 .5 .4; 1 0 0; .4 0 0]);
        
    case 'gold'
        map = colormap_via([0 0 0; .5 0 0; 1 .5 0; 1 1 .5; 1 1 1]);

    case 'gold2'
        map = colormap_via([.6 .6 .6; 0 0 0; .5 0 0; 1 .5 0; 1 1 .5; 1 1 1],...
            [0 1/2 5/8 6/8 7/8 1]);

    case 'ice'
        map = colormap_via([0 0 0; 0 0 .5; 0 .5 1; 0.5 1 1; 1 1 1]);
        
    case 'green'
        map = colormap_via([0 0 0; 0 .5 0; .5 1 0; 1 1 .5; 1 1 1]);

    case 'green2'
         map= colormap_via([0 .2 0; 0 .6 0; 0 1 0; .5 1 .5; 1 1 1]);
%        map= colormap_via([0 .25 0; 0 .6 .18; 0 1 .25; 1 1 1]);

    case 'kjet'
        map = colormap_via([1 1 1; 1 1 1; 0 0 1; 0 1 1; 1 1 0; 1 0 0; 0 0 0],...
            [0 0.07 0.25 0.39 0.47 0.68 1]);
        
    case 'kjetb'
        map = colormap_via([0 0 0; 0 0 1; 0 1 1; 1 1 0; 1 0 0; 0 0 0],...
            [0 0.25 0.45 0.55 0.75 1]);
        
    case 'nd'
        map = colormap_via([0 0 0; .01 .17 .36;.86 .71 .22; 1 1 1]);

    case 'sunrise'
        map = colormap_via([0 0 0; 0 0 1; 1 0 0; 1 1 0; 1 1 1]);
    
    case 'pink'
        map = colormap_via([1 0.08 .6; .9 .8 .9]);
        
    case 'pink-lemonade'
        map = colormap_via([1 1 1; 1 1 1; 1 0 0; 1 0 0; 1 .5 0; 1 .5 0; 1 1 0],...
            [0 0.07 0.25 0.39 0.47 0.68 1]);
        
    case 'purple-yellow'
        map = colormap_via([0 0 0; .5 0 1; 1 1 0]);
        
    case 'rainbow'
        map = colormap_via([1 0 0; 1 0 1],'hsv');
        
    case 'red'
        map = colormap_via([0 0 0; .5 0 0; 1 0 .5; 1 .5 1; 1 1 1]);
        
    case 'hot' % for reference
        map = colormap_via([0 0 0; 1 0 0; 1 1 0; 1 1 1], [0 3/8 6/8 1]);

    case 'hsv'  % for reference
        map = colormap_via([0 1 1; (map_length - 1)/map_length 1 1], 'HSV');
       
    case 'jet'  % for reference -- but only identical for length 256. 
        map = colormap_via([0 0 .5; 0 0 1; 0 1 1; 1 1 0; 1 0 0; .5 0 0],...
            [0 1/8 3/8 5/8 7/8 1]);
  
        
    otherwise
        error ('Never heard of this map.');
end;

% make the map the appropriate length
cmap1=zeros(map_length,3);
for column = 1:3
    cmap1(:,column) = interp1(map(:,column), linspace(1, size(map,1), map_length));
end;

if nargout == 0
    colormap(cmap1);
else
    cmap=cmap1;
end;