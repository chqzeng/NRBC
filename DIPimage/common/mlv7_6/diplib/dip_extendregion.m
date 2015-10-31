%dip_extendregion   Image manipulation functions.
%    out = dip_extendregion(image, origin, regDims, ordering)
%
%   image
%      Image.
%   origin
%      Integer array.
%   regDims
%      Integer array.
%   ordering
%      Integer array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,February 2000.

%   FUNCTION:
%This functions extends a region in an image with a specified boundary condition.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image image      IMAGE *image      Image
%  dip_IntegerArray origin    int ox, oy     Origin
%  dip_IntegerArray regDims      int rx, ry, rz    RegDims
%  dip_BoundaryArray bc          Boundary conditons
%  dip_IntegerArray ordering     int ordering      Ordering
%  dip_Image *imValues     IMAGE **imValues     Complex values
%
