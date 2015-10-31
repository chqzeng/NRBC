%DOUBLE   Convert dip_image object to double matrix.
%   A = DOUBLE(B) converts the dip_image B to a double precision
%   n-dimensional matrix.
%   If B is a dip_image_array the array components are added as extra
%   dimensions to A.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February 1999.
% 24 July 2000: If IN is a dip_image_array, and each image in it has only
%               one pixel, an array is returned. This allows stuff like
%               DOUBLE(A(0,0)) to return a tensor if A is a tensor image
%               (ISTENSOR returns TRUE)
% 15 August 2008: Calling DIP_ARRAY. (BR)

function out = double(in)
out = dip_array(in,'double');
