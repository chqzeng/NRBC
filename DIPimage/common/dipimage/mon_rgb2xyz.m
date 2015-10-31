%MON_XYZ2RGB   RGB to XYZ transformation for a calibrated monitor
%
% SYNOPSIS:
%  image_out = mon_xyz2rgb(image_in, rgb_xyz, gammaval)
%
% DEFAULTS:
%  rgb_xyz  = [ 3.50969    -1.74031  -0.545358
%              -1.06828     1.97725   0.0345393
%               0.0552852  -0.196645  1.05062   ]^(-1);
%  gammaval = [1.0 1.0 1.0];
%
% DESCRIPTION:
%  This function is used to transform RGB values to XYZ values for a
%  calibrated monitor.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 21 October 2007: Moved to toolbox directory. (CL)

function out = mon_rgb2xyz(in, rgb2xyz_mat, gamma)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in) | ~strcmp( colorspace(in), 'RGB'),
   error('The input image should be in the RGB colorspace');
end
if(nargin < 3)
   gamma = [1,1,1];
else
   gamma = gamma(:)';
   if length(gamma)==1
      gamma = repmat(gamma,1,3);
   end
   if length(gamma)~=3
      error('Gamma should be one or three values');
   end
end

if( nargin < 2)
   rgb2xyz_mat = [3.50969  -1.74031  -0.545358
                  -1.06828  1.97725  0.0345393
                  0.0552852  -0.196645  1.05062]^(-1);
end

out = dip_image('array',[3,1]);
out{:} = in; % To make sure that the array is a column vector.
out = out./255;
out{1} = out{1}^(1/gamma(1));
out{2} = out{2}^(1/gamma(2));
out{3} = out{3}^(1/gamma(3));
out = rgb2xyz_mat * out;
out = colorspace(out, 'XYZ');
