%RGB_TO_BORDER   Determines points on the gamut boundary in a certain direction
%
% SYNOPSIS
%  [image_up, image_down] = rgb_to_border(image_in, direction)
%
% DEFAULTS:
%  direction = 1
%
% DESCRIPTION:
%  For each pixel in the image the color on the upper gamut boundary (image_up)
%  and the color on the lower gamut boundary (image_down) are determined.
%  There are two directions implemented:
%  1:   The direction of constant hue and chroma, so the only difference
%       between image_in, image_up and image_down is their luminance value.
%       Note that in RGB representation, in each pixel of image_up, R, G, or B
%       is 255, whereas in image_down, one of the color values is 0.
%  2:   The direction of constant chroma. image_down is always (0, 0, 0)

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet W. Verbeek
% implemented in dipimage: Judith Dijk, July 2002.
% 20 October 2007: Moved to toolbox directory, simplified code. (CL)

function [up, down] = rgb_to_border(in, direction)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   up = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in)
   error('Input needs to be a color image.');
end

if nargin < 2, direction = 1; end

ori_col = colorspace(in);
in = colorspace(in, 'RGB');

if direction == 1
   Largest=imarfun('immax',in);
   Smallest=imarfun('immin',in);
   up=in+255-Largest; % up: same Hue and Chroma, but Value=255
   down=in-Smallest;  % down: same Hue and Chroma, but Smallest=0
else
   Value = imarfun('immax',in);  % max(max(in(1),in(2)),in(3));
   mask = Value>0.001;
   Value = Value*mask + (~mask);
   up = (255*in./Value).*mask;
   down = up*0;
end
up = colorspace(up, ori_col );
down = colorspace(down, ori_col );
