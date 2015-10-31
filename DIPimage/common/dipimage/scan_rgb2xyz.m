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
%  This function is used to transform RGB values to XYZ values using a
%  calibrated scanner model. This model is a first, second or third order
%  polynomial. The transformation matrix can be made with
%  scanner_calibration.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2002.
% 21 October 2007: Moved to toolbox directory. (CL)

function out = scan_rgb2xyz(in, rgb2xyz_mat)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in) | ~strcmp( colorspace(in), 'RGB')
   error('The input image should be in the RGB colorspace');
end

if( nargin < 2)
   rgb2xyz_mat = [3.50969  -1.74031  -0.545358
                  -1.06828  1.97725  0.0345393
                  0.0552852  -0.196645  1.05062]^(-1);
end

out = dip_image('array',[3,1]);
out{:} = in; % To make sure that the array is a column vector.
             % This also looses the colorspace information.
out = out./255;

if( size(rgb2xyz_mat, 2) == 3)
   out = rgb2xyz_mat * out;
elseif( size(rgb2xyz_mat, 2) == 9)
   R = out{1};
   G = out{2};
   B = out{3};
   x = rgb2xyz_mat(1, :);
   out{1} = x(1).*R + x(2).*G + x(3).*B  + ...
       x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
       x(7).*R.*G + x(8).*R.*B + x(9).*G.*B;
   x = rgb2xyz_mat(2, :);
   out{2} = x(1).*R + x(2).*G + x(3).*B  + ...
       x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
       x(7).*R.*G + x(8).*R.*B + x(9).*G.*B;
   x = rgb2xyz_mat(3, :);
   out{3} = x(1).*R + x(2).*G + x(3).*B  + ...
       x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
       x(7).*R.*G + x(8).*R.*B + x(9).*G.*B;
elseif( size(rgb2xyz_mat, 2) == 19)
   R = out{1};
   G = out{2};
   B = out{3};
   x = rgb2xyz_mat(1, :);
   out{1} = x(1).*R + x(2).*G + x(3).*B  + ...
      x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
      x(7).*R.*G + x(8).*R.*B + x(9).*G.*B + ...
      x(10).*R.^3 + x(11).*G.^3 + x(12).*B.^3 + ...
      x(13).*R.^2.*G + x(14).*R.^2.*B + x(15).*G.^2.*R +...
      x(16).*G.^2.*B + x(17).*B.^2.*R + x(18).*B.^2.*G + ...
      x(19).*R.*G.*B;
   x = rgb2xyz_mat(2, :);
   out{2} = x(1).*R + x(2).*G + x(3).*B  + ...
      x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
      x(7).*R.*G + x(8).*R.*B + x(9).*G.*B + ...
      x(10).*R.^3 + x(11).*G.^3 + x(12).*B.^3 + ...
      x(13).*R.^2.*G + x(14).*R.^2.*B + x(15).*G.^2.*R +...
      x(16).*G.^2.*B + x(17).*B.^2.*R + x(18).*B.^2.*G + ...
      x(19).*R.*G.*B;
   x = rgb2xyz_mat(3, :);
   out{3} = x(1).*R + x(2).*G + x(3).*B  + ...
      x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
      x(7).*R.*G + x(8).*R.*B + x(9).*G.*B + ...
      x(10).*R.^3 + x(11).*G.^3 + x(12).*B.^3 + ...
      x(13).*R.^2.*G + x(14).*R.^2.*B + x(15).*G.^2.*R +...
      x(16).*G.^2.*B + x(17).*B.^2.*R + x(18).*B.^2.*G + ...
      x(19).*R.*G.*B;
else
   error('The transformation matrix does not have the right dimensions');
end

out = colorspace(out, 'XYZ');
