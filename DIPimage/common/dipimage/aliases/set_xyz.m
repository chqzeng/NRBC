%  SET_XYZ   Set the whitepoint of the XYZ colorspace.
%
%  SYNOPSIS:
%     image_out = set_xyz(image_in, new_xyz)
%
%  DEFAULTS:
%     new_xyz = [0.9505 1 1.0888]  (D65 white)
%
%  DESCRIPTION:
%     The whitepoint of the input image is reset into the new value (XYZ_new).
%     Note the difference with CHANGE_XYZ, where the pixel values of the input
%     image are changed due to the change in the white reference
%
%  EXAMPLE:
%     a = set_xyz( readcolorim, [0.9642 1 0.8249])  %(D50 white)

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 10 March 2008: Added whitepoint property to image object indexing. (CL)

function in = set_xyz(in,XYZ_out)

if nargin<2
   XYZ_out = di_defaultwhite;
end
in.whitepoint = XYZ_out;
