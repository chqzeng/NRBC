%ISO_LUMINANCE_LINES   Plot lines with same luminance in color image
%
% SYNOPSIS:
%  image_out = iso_luminance_lines(image_in, number_of_lines)
%
% DEFAULTS:
%  number_of_lines = 10
%
% DESCRIPTION:
%  A number of curves (lines) connecting points with the same luminance are
%  drawn in the input image.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet W. Verbeek
% implemented in dipimage: Judith Dijk, June 2002.
% 20 October 2007: Moved to toolbox directory. (CL)

function out = iso_luminance_lines(in, number)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

in = dip_image(in);

if nargin < 2,number = 10; end

if ~iscolor(in)
   Y8 = stretch(in,0,100,0,1) * number;
   Y8 = threshold( Y8 - floor( Y8 ), 'fixed', 0.015 * number);
   out = Y8 * in;
else
   ori_col = colorspace(in);
   out = colorspace(in,'Yxy');
   Y8 = out{1} * number;
   Y8 = threshold( Y8 - floor( Y8 ), 'fixed', 0.015 * number);
   out{1} = Y8 * out{1};
   out = colorspace( out, ori_col);
end
