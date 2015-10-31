%dip_map   Remaps an image.
%    out = dip_map(in, map, mirror)
%
%   in
%      Image.
%   map
%      Integer array.
%   mirror
%      Boolean array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%binary, integer, float, complex
%FUNCTION
%This function maps the dimensions of the output image to (different) dimensions of the input image. The array index of map specifies the dimension of the
%output image, the value of the array element of map specifies to which
%dimension in the input image it corresponds. Optionally, the dimensions can
%be mirrored, when the value of the corrsponding array element in mirror is
%set to DIP_TRUE.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_IntegerArray map    IntegerArray map     Map array
%  dip_BooleanArray mirror    ../Text/DimensionToggle.html mirror    Mirror array
%
%SEE ALSO
% Mirror
