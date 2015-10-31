%
% Grey-value color map with the middle intensity grey, negative
% intensities blue and positive intensities yellow.
%

% New & improved, 31 March 2009, Cris Luengo, Centre for Image Analysis, Uppsala.

function g = zerobased_colormap

gv = 0.4;
a = linspace(gv,1.0,128)'; % blue
b = linspace(gv,0.9,128)'; % yellow
c = linspace(gv,0.0,128)'; % black
g = [flipud([c,c,a]);b,b,c]; % blue-yellow

%g = [flipud([b,b,a]);a,b,b]; % blue-red
