%OUT_OF_GAMUT   Determine which colors of an image are outside the gamut
%
% SYNOPSIS:
%  image_out = out_of_gamut( image_in, gamut_data)
%
% DEFAULTS:
%  gamut_data = standard RGB gamut (D65, 2 degrees observer)
%
% DESCRIPTION:
%  The output of this function is a binary image in which a 1 represents pixels
%  that are outside the provided gamut. This means that these pixels cannot be
%  displayed on the device to which the gamut belongs.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 20 October 2007: Moved to toolbox directory. (CL)

function out = out_of_gamut(in, gamut_data)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in)
   error('Input needs to be a color image.');
end

if nargin < 2 | isempty(gamut_data)
   gamut_data = make_gamut;
end

lab_in = colorspace(in, 'lab');
clipped_im = gamut_mapping( lab_in, 'chord_clip', gamut_data );
% if the clipped im is different than the original, the pixels are out-of-gamut.
out = abs( clipped_im{1} - lab_in{1}) > 0.000001;
