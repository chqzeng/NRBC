%  GET_XYZ   Retrieve the whitepoint of the XYZ colorspace.
% 
%  SYNOPSIS:
%     xyz_image_in = get_xyz(image_in)
% 
%  DEFAULTS:
%
%  DESCRIPTION:
%     The whitepoint of the input image is retreived. If the input image does
%     not contain this information yet, the standard whitepoint 
%     [0.9505 1 1.0888]  (D65 white) is returned. 
%
%  EXAMPLE:
%    xyz_out = get_xyz( readcolorim)

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 10 March 2008: Added whitepoint property to image object indexing. (CL)

function out = get_xyz(in)

out = in.whitepoint;
