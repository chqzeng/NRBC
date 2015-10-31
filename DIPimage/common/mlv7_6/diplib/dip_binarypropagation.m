%dip_binarypropagation   Binary Mathematical Morphology.
%    out = dip_binarypropagation(inSeed, inMask, connectivity,...
%          iterations, edge_condition)
%
%   inSeed
%      Image.
%   inMask
%      Image.
%   connectivity
%      Integer number.
%         number <= dimensions of in
%         pixels to consider connected at distance sqrt(number)
%   iterations
%      Integer number.
%   edge_condition
%      Boolean number (1 or 0).

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
%At this moment this function only supports images with a dimensionality up to
%three. The connectitivity parameter supports only the following values:
%in 2D: 4, 8, 48 and 84, and in 3D: 6, 18, 26. The edge parameter specifies
%whether the border of the image should be treated as object (DIP_TRUE) or
%as background (DIP_FALSE). The terations parameter specifies the number of
%dilations the algorithm should perform. If zero is speficied, the propagation
%continues until a stable result is obtained.
%See this section for a description of binary
%mathematical morphology operations, and
% this section for applications of binary propagation.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image seed    IMAGE *seed    Input seed
%  dip_Image mask    IMAGE *mask    Input mask
%  dip_Image out     IMAGE *out     Output
%  dip_int connectivity    int connectivity     Connectivity
%  dip_int iterations (0)     int iterations    Iterations
%  dip_Boolean edge     int edge    Edge condition
%
%KNOWN BUGS
%This function is only implemented for images with a dimension up to three.
%SEE ALSO
% BinaryDilation , BinaryErosion , BinaryClosing , BinaryOpening , RemoveEdgeObjects
