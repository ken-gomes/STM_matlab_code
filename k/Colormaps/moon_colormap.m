function varargout = moon_colormap(map_name, map_length)
% Changes the colormap to one of my lovely creations
%
% moon_colormap(map_name, map_length)
%
% map = moon_colormap(map_name, map_length) returns the map and does not change the current map
%
% CRM 2006-10-20

if nargin < 2, map_length = 256; end

switch map_name
    case 'amber'
        % I use this one for dI/dV maps
        map = colormap_via([0 0 0; .15 0 0; .5 0 0; 1 1 0], [0 .2 .4 1]);

    case 'amber1'
        % The original amber before tweaking -- very similar, but a bit darker
        map = colormap_via([0 0 0; .2 0 0; .5 0 0; 1 1 0]);

    case 'arctic'
        % Icy blue
        map = colormap_via([0 0 1; .8 .8 1]);
        
    case 'cardinal'
        map = colormap_via([255 255 255; 164 0 29]/255);  % official!

    case 'blackbody'
        map = colormap_via([0 0 0; .5 0 0; 1 .5 0; 1 1 .5; 1 1 1]);
        
    case 'hot' % for reference
        map = colormap_via([0 0 0; 1 0 0; 1 1 0; 1 1 1], [0 3/8 6/8 1]);

    case 'gnarly'
        map = colormap_via([0 0 0; 0 .5 0; 0 1 1/3; 1 0 1; 1 0 0; 1 1 0],[0 1/8 1/4 1/2 3/4 1]);
        
    case 'hsv'  % for reference
        map = colormap_via([0 1 1; (map_length - 1)/map_length 1 1], 'HSV');
        
    case 'hari8' % more or less
       map = colormap_via([.91 0 0; 1 0 0; 1 .9 0; .85 1 0; .44 1 .06; .03 .52 .21; .5 0 .62; 1 0 .98; 1 0 .98],[0 .08 .32 .37 .47 .64 .84 .96 1],[],'cubic');
       
    case 'jet'  % for reference -- but only identical for length 256. 
        map = colormap_via([0 0 .5; 0 0 1; 0 1 1; 1 1 0; 1 0 0; .5 0 0],[0 1/8 3/8 5/8 7/8 1]);

    case 'line'   % for line_colormap
        % 1.5 is lightish green, and 6.5 -> 0.5 is orange. 1.0 is yellow
        % which is being avoided here, for legibility
        h = mod(linspace(2,6,map_length)'/6,1);   % hue, no yellow
        map = hsv2rgb([h ones(map_length,2)]);

    case 'line2'   % for line_colormap
        h = mod(linspace(4,6,map_length)'/6,1);
        map = hsv2rgb([h ones(map_length,2)]);
        
    case 'magenta' % black -> magenta
        map = colormap_via([0 0 0; 1 0 1]);

    case 'punch'
        map = colormap_via([0 0 0; 0 0 1; 1 0 0]);
        
    case 'purple-yellow'
        map = colormap_via([0 0 0; .5 0 1; 1 1 0]);
        
    case 'rainbow'
        map = colormap_via([1 0 0; 1 0 1],'hsv');

    case 'romance'
        % Lovely pink
        map = colormap_via([1 0 1; .9 .8 .9]);

    case 'sunrise'
        map = colormap_via([0 0 0; 0 0 1; 1 0 0; 1 1 0; 1 1 1]);

    case 'sunrise2'   % this is sunrise with a bluer beginning. used for isospectral.
        map = colormap_via([0 0 .5; 0 0 1; 1 0 0; 1 1 0; 1 1 1]);
        
    case 'sunrise3'   % sunrise that ends with light yellow, not white. for berry.
        map = colormap_via([0 0 0; 0 0 1; 1 0 0; 1 1 0; 1 1 .5],[(0:3)/4*8/7 1]);
        
    case 'test'
        colormap_via([0 0 0; .5 0 1; 1 0 1; 1 0 0; 1 .5 0]);
        
    case 'test2'
        colormap_via([0 0 0; 0 0 1; 1 1 0; 1 0 0]);
        
    case 'test3'
        colormap_via([0 0 0; 0 0 1; 1 0 1; 1 0 0; 1 1 0]);
        

    otherwise
        error('Unknown map.');
end

% make the map the appropriate length
for column = 1:3
    newmap(:,column) = interp1(map(:,column), linspace(1, size(map,1), map_length));
end

map = newmap;

if nargout == 0
    colormap(map);
end

if nargout > 0, varargout = {map}; end