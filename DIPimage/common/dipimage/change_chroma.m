%CHANGE_CHROMA   Change the saturation of the image (CIELAB/CIELUV space)
%
% SYNOPSIS:
%  image_out = change_chroma(image_in, fraction, col)
%
% DEFAULTS:
%  frac = 1         (Nothing changes)
%  col  = 'L*a*b*'
%
% DESCRIPTION:
%  The chroma of the input image is scaled with a fraction. If this fraction
%  is larger than 1, the image gets more colorful. If the fraction is smaller
%  than 1, the image gets desaturated. This manipulation can be done in
%  CIELAB, CIELUV  and RGB space.
%  Note that with a fraction larger than 1 the number of out-of-gamut pixels
%  increases.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 20 October 2007: Moved to toolbox directory, simplified. (CL)

function out = change_chroma(in, frac, col)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in)
   error('Input needs to be a color image.');
end
if nargin < 2, frac = 1; end % Nothing changes
if nargin < 3, col = 'L*a*b*'; end;

switch lower(col)
   case {'lab','cielab','l*a*b*'}
      col = 'L*a*b*';
   case {'luv','cieluv','l*u*v*'}
      col = 'L*u*v*';
   case {'rgb'}
      col = 'RGB';
   otherwise
      error('Cannot perform operation in requested colorspace');
end

col_in = colorspace(in);
if strcmp(col, 'RGB')
   out = colorspace(in, 'RGB');
   Y = colorspace( out, 'grey')./255;
   out = frac * out + (1-frac) * 255 * Y;
else
   out = colorspace(in, col); % Lab or Luv
   out{2} = out{2}.*frac;
   out{3} = out{3}.*frac;
end
out = colorspace(out, col_in);
