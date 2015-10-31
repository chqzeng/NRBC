%
% Grey-value color map that shows values of 255 in red and 0 in blue.
%
function g = saturation_colormap
g = linspace(0,1,256)';
g = [g,g,g];
g(1,:) = [0,0,1];
g(256,:) = [1,0,0];
