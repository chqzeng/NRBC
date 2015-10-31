%dip_ellipticdistancetopoint   Distance generation function.
%    out = dip_ellipticdistancetopoint(out, origin, scale)
%
%   out
%      Image.
%   origin
%      Real array.
%   scale
%      Real array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%Output: sfloat
%FUNCTION
%Computes the elliptic distance of each pixel in the output image
%to a point at origin. The coordinates of origin may lie outside the image.
%The scale parameter may be used to specify the relative distance between
%pixels in each dimension.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image output     IMAGE *output     Output Image
%  dip_FloatArray origin      double oX, oY, oZ    Coordinates of the Origin
%  dip_FloatArray scale    double sX, sY, sZ    Relative scale of the pixel distances for each dimension
%
%SEE ALSO
% EuclideanDistanceToPoint , CityBlockDistanceToPoint
