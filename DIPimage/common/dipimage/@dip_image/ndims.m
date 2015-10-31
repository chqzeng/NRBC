%NDIMS   Return the number of dimensions in the image.
%   NDIMS(B) returns the number of dimensions of the image in B.
%
%   If B is an array of images, NDIMS returns the number of
%   dimensions of the array itself, not of the images.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February/May 1999.
% 24 July 2000: Now also works on dip_image_arrays.

function n = ndims(in)
if isscalar(in)
   n = in.dims;
else
   n = builtin('ndims',in);
end
