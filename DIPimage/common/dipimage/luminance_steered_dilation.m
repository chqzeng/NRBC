%LUMINANCE_STEERED_DILATION   Dilation on color image with luminance ordering
%
% SYNOPSIS
%  image_out = luminance_steered_dilation(image_in, size)
%
% DEFAULTS:
%  size = 7
%
% DESCRIPTION:
%  A dilation on the color image is determined in which the ordering is
%  taken as the largest luminance value in the neighbourhood. So, in the
%  given neighbourhood the points with the largest luminance is determined,
%  and then the colors of that points are given in the output point.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet W. Verbeek
% implemented in dipimage: Judith Dijk, August 2002.
% 20 October 2007: Moved to toolbox directory, allowing nD images. (CL)

function out = luminance_steered_erosion(in,sz)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

in = dip_image(in);

if ~iscolor(in), error('the input image should be a colorimage'); end
if nargin < 2, sz = 7; end
nd = length(imsize(in));
if length(sz)>nd
   sz = sz(1:nd);
elseif length(sz)<nd
   sz(end+1:nd) = sz(end);
end

Y = colorspace(in, 'grey');
out = in;
for ii=1:prod(imarsize(in))
   % The next line overwrites the data, but not the colorspace information.
   out{ii}(:) = dip_generalisedkuwahara(in{ii},Y,[1],sz,'elliptic',0);
end
