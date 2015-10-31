%dip_wrap   Wrap an image.
%    out = dip_wrap(in, wrap)
%
%   in
%      Image.
%   wrap
%      Integer array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-July 1999.

%   DATA TYPES:
%binary, integer, float, complex
%FUNCTION
%This function wraps the in image around its image borders. wrap specifies
%the number of pixels over which the image has to wrapped in each dimension.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_IntegerArray wrap      int wx, wy, wz    Wrap parametrs
%
%SEE ALSO
% Wrap , Crop , Shift
