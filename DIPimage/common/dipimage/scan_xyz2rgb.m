%SCAN_XYZ2RGB   XYZ to RGB transformation for a calibrated scanner
%
% SYNOPSIS:
%  image_out = scan_xyz2rgb(image_in, rgb_xyz)
%
% DEFAULTS:
%  rgb_xyz = [ 3.50969    -1.74031  -0.545358
%             -1.06828     1.97725   0.0345393
%              0.0552852  -0.196645  1.05062   ]^(-1);
%
% DESCRIPTION:
%  This function is used to transform XYZ values to RGB values using a
%  calibrated scanner model. This model is a first order model.
%  The transformation matrix can be made with scanner_calibration.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2002.
% 21 October 2007: Moved to toolbox directory. (CL)

% The second and third order polynomials are not implemented. This
% transformation is rarely used.

function out = scan_xyz2rgb(in, rgb2xyz_mat)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in) | ~strcmp(colorspace(in), 'XYZ')
   error('The input image should be in the XYZ colorspace');
end

if( nargin < 2)
   rgb2xyz_mat = [3.50969  -1.74031  -0.545358
                  -1.06828  1.97725  0.0345393
                  0.0552852  -0.196645  1.05062]^(-1);
end

out = dip_image('array',[3,1]);
out{:} = in; % to make sure that the array is a column vector.
             % This also looses the colorspace information.
out = rgb2xyz_mat^(-1) * out;
out = out.*255;
out = colorspace(out, 'RGB');
