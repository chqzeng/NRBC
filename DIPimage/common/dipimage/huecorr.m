%HUECORR   Changing the hue in the HSV colorspace
%
% SYNOPSIS:
%  image_out = function(image_in, fact, root1, root2, root3, shift_val)
%
% DEFAULTS:
%  fact      = -0.1125
%  root1     = 0
%  root2     = 2
%  root3     = 2
%  shift_val = 0.75
%
% DESCRIPTION:
%  The hue (in HSV) is transformed with the following formula:
%     h_out = 3* (h+shift_val + fact( h+shift_val-root1) (h+shift_val-root2)
%         (h+shift_val-root3))
%  The goal of this transformation is to obtain a better sampling of the
%  colorcircle. A polynomial is added to the hue, with certain zero crossings
%  on which the hue will remain constant.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet W. Verbeek
% implemented in dipimage: Judith Dijk, June 2002.
% 20 October 2007: Moved to toolbox directory, fixed to actually work (!). (CL)

function out = huecorr(in,fact,root1,root2,root3, shift_val)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in)
   error('Input needs to be a color image.');
end

if nargin < 2, fact = -0.1125; end
if nargin < 3, root1 = 0; end
if nargin < 4, root2 = 2; end
if nargin < 5, root3 = 2; end
if nargin < 6, shift_val = 0.75; end

ori_col = colorspace(in);
ori_xyz = in.whitepoint;
cc = colorspace(in, 'HSV');
cc{1} = shift_val+cc{1};
cc{1} = 3*polycorr(cc{1}/3,fact,root1,root2,root3);
out = colorspace(cc, ori_col);

%polycorr
function out = polycorr( in, fact, root1, root2, root3)
out = in + fact * ( in - root1 ) * (in - root2) * ( in - root3 );
