%PRINT_CMY2XYZ   CMY to XYZ transformation for a calibrated printer
%
% SYNOPSIS:
%  image_out = print_cmy2xyz(image_in, cmy_ref, xyz_ref)
%
% DESCRIPTION:
%  This function is used to transform CMY values to XYZ values using a
%  (measured?) interpolation table. The values in cmy_ref should be equally
%  spaced over the CMY colorspace.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2002.
% 21 October 2007: Moved to toolbox directory. (CL)

function out = print_cmy2xyz(in, cmy_ref, xyz_ref)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in) | (~strcmp(colorspace(in), 'CMY') & ~strcmp(colorspace(in, 'CMYK')))
   error('The input image should be in the CMY(K) colorspace');
end
if ~isa(cmy_ref,'dip_image_array') | ~iscolor(cmy_ref) | ~strcmp(colorspace(cmy_ref), 'CMY')
   error('The CMY reference values should be in the CMY colorspace');
end
if ~isa(xyz_ref,'dip_image_array') | ~iscolor(xyz_ref) | ~strcmp(colorspace(xyz_ref), 'XYZ')
   error('The XYZ reference values should be in the XYZ colorspace');
end
if nargin < 3
   error('Not enough input arguments');
end

num_points = prod(imsize(xyz_ref));
num_points_cmy = prod(imsize(cmy_ref));
if( num_points ~= num_points_cmy)
   error('The two reference images should have equal dimensions');
end

num_points = num_points.^(1/3);
if( abs(num_points - round(num_points)) > 0.0001)
   error( 'The reference image does not have correct dimensions');
end

in = colorspace(in, 'CMY'); % In case it's CMYK
in1 = double(in{1});
in2 = double(in{2});
in3 = double(in{3});

xyz_double1 = double(xyz_ref{1});
xyz_double2 = double(xyz_ref{2});
xyz_double3 = double(xyz_ref{3});
cmy_double1 = double(cmy_ref{1});
cmy_double2 = double(cmy_ref{2});
cmy_double3 = double(cmy_ref{3});

matrix_in = [cmy_double1(:), cmy_double2(:), cmy_double3(:), ...
   xyz_double1(:), xyz_double2(:), xyz_double3(:)];

[out1, out2, out3] = lin_interpol_3(in1, in2, in3, matrix_in);

out = joinchannels('XYZ',  out1, out2, out3);
