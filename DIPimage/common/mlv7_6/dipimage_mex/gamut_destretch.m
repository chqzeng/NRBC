%GAMUT_DESTRETCH   Transforming the gamut from ideal lines to its original shape
%
% SYNOPSIS:
%  image_out = gamut_destretch(image_in, gamut_data_lines, device_values, ...
%              reference_values)
%
% DEFAULTS:
%  device_values    = from standard RGB cube.
%  reference_values = from standard RGB cube.
%
% DESCRIPTION:
%  In this function the gamut is destretched in the LC plane. It is assumed
%  that a stretching has taken place in an earlier stage.
%
%  For each pixel point the plane with a constant hue through the gamut is
%  determined. In these plane all points are manipulated in such a way, that
%  the ideal triangle shape is deformed into the original shape. All points
%  keep their original chroma, and are scaled in the luminance direction
%  such that the line through the cusp point remains at its position. All
%  other luminances are scaled linearly between the gamut boundary and the
%  line through the cusp point.
%
% SEE ALSO: gamut_stretch

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, 5 October 2001, adjusted 3 June 2002.
% 20 October 2007: Moved to toolbox directory. (CL)

function  out = gamut_destretch(in, gamut_data_lines, device_vals, ref_vals)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in)
   error('Input needs to be a color image.');
end

if( nargin < 3)
   gamut_data = make_gamut;
else
   gamut_data = make_gamut(device_vals, ref_vals);
end

ori_col = colorspace(in);
out = colorspace(in, 'lab');

L_im = double(out{1});
a_im = double(out{2});
b_im = double(out{3});

cusp_L = double(gamut_data_lines{1});
cusp_C = double(gamut_data_lines{2});
offset_max= double(gamut_data_lines{3});
offset_min = double(gamut_data_lines{4});

% This is the c procedure of interest. All triangles are checked to see if they
% cross the hue plane, if so, it is checked whether they are on the correct
% line.
L_out = gamut_stretch_reverse(L_im, a_im, b_im, gamut_data', ...
                              cusp_L, cusp_C, offset_max, offset_min);

out{1} = L_out;
out = colorspace(out, ori_col);
