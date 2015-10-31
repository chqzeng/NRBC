%dip_edgeobjectsremove   Remove binary edge objects.
%    out = dip_edgeobjectsremove(in, connectivity)
%
%   in
%      Image.
%   connectivity
%      Integer number.
%         number <= dimensions of in
%         pixels to consider connected at distance sqrt(number)

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%binary
%FUNCTION
%The function EdgeObjectsRemove() removes those binary objects from in
%which are connected to the edges of the image. The connectivity of the
%objects is determined by connectivity. This function is a front-end to
%BinaryPropagation(). It calls BinaryPropagation with no seed image and
%the edge pixels turned on. The result of the propagation is xor-ed with
%the input image.
%The connectitivity parameter supports only the following values:
%in 2D: 4, 8, 48 and 84, and in 3D: 6, 18, 26.
%See  this section for a description of the edge object removal operation.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Binary input image
%  dip_Image out     IMAGE *out     Output
%  dip_int connectivity    int connectivity     Pixel connectivity
%
%KNOWN BUGS
%This function is only implemented for images with a dimension up to three.
%SEE ALSO
% BinaryPropagation , Xor
