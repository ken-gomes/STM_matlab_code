function varargout = colormap_via(rgbs, indices, mode, n_colors, interp_method)
% function color_map = colormap_via(rgbs, indices, mode)
%
% makes a 256-deep colormap by interpolating between rgb vectors in rgb colorspace
%
% rgbs is a matrix whose rows are rgb vectors ranging from 0 to 1
%
% if indices is supplied, they specify the positions between 0 and 1 at
% which each color occurs. The first color should probably be at 0 and the
% last at 1; out-of-bounds colors will appear black.
%
% examples:
%
%   this is a red -> white -> blue colormap:
%      colormap(colormap_via([1 0 0; 1 1 1; 0 0 1]));
%
%   this makes white occur later in the map, so it looks more red/pink:
%      colormap(colormap_via([1 0 0; 1 1 1; 0 0 1], [0 0.75 1]));
%
%
% also try: colormap_via(rgbs, indices, mode) or
%           colormap_via(rgbs, mode)
%   where mode is 'hsv' or 'hsl' for interesting results
%
% if you need the hues to wrap around (i.e. not interpolate backwards), do
%     colormap_via(hsvs, 'HSV+')
%
% if mode is in all caps, this signifies that the rgbs are actually in that format
%
% also try:
%    colormap_via(rgbs, indices, mode, interp_method)
%      where n_colors is the length of the map (256)
%      and setting interp_method to 'cubic' (default 'linear')
%
% the most general call is:
%    colormap_via(rgbs, indices, mode, n_colors, interp_method)
%
% see moon_colormap for known-awesome colormaps and more examples
%
% CRM 10-09-2006


if nargin < 3 || isempty(mode),
    mode = 'rgb';
end

if nargin < 4 || isempty(n_colors),
    n_colors = 256;
end

if nargin < 5 || isempty(interp_method)
    interp_method = 'linear';
end

if isnumeric(mode)  % mode is really n_colors
    n_colors = mode;
    mode = 'rgb';
end

if ischar(n_colors) % n_colors is really interp_method
    interp_method = n_colors;
    n_colors = 256;
end

n = size(rgbs, 1);  % number of specified colors

if nargin > 1
    if length(indices) == 1
        n_colors = indices;
        indices = [];
    end

    if ischar(indices)  % colormap_via(rgbs, mode)
        mode = indices;
        indices = [];
    end
end

if nargin < 2 || isempty(indices)
    indices = linspace(0,1,n);
end

% if the color mode ends with a +, make the hues strictly increasing
if mode(end) == '+'
    increasing_hues = 1; mode(end) = [];
else
    increasing_hues = 0;
end



indices_new = linspace(0, 1, n_colors);

switch mode
    case {'hsl'}
        colors = rgb2hsl(rgbs);
    case {'hsv'}
        colors = rgb2hsv(rgbs);
    otherwise
        colors = rgbs;
end

% if all caps, input is already in that format
switch mode
    case {'HSL'}
        mode = 'hsl';
    case {'HSV'}
        mode = 'hsv';
end

% if requested, make the hues strictly increasing
if increasing_hues
    for k = 2:n
        if colors(k,1) < colors(k-1,1)
            colors(k:end,1) = colors(k:end,1) + 1;
        end
    end
end
        
% Interpolate
color_map = interp1(indices, colors, indices_new, interp_method);

% mod the hue into range if applicable
if strcmpi(mode,'hsv') || strcmpi(mode, 'hsl')
    color_map(:,1) = mod(color_map(:,1),1);
end

% Return the colormap in RGB
switch mode
    case {'hsl'}
        color_map = hsl2rgb(color_map);
    case {'hsv'}
        color_map = hsv2rgb(color_map);
end

% In case of silly machine errors
color_map = max(color_map, 0);
color_map = min(color_map, 1);

if nargout == 0, 
    colormap(color_map); 
    if n_colors > 256, set(gcf, 'renderer', 'zbuffer'); end
else
    varargout = {color_map};
end