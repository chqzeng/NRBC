%dip_euclideanskeleton   binary skeleton operation.
%    out = dip_euclideanskeleton(in, endpixelCondition, edgeCondition)
%
%   in
%      Image.
%   endpixelCondition
%      End pixel condition. String containing one of the following values:
%      'looseendsaway', 'natural', '1neighbor', '2neighbors', '3neighbors'.
%   edgeCondition
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
%This function calculates an accurate (euclidean)skeleton.
%It tests Hilditch conditions to preserve topology.
%The algorithms uses the following distance metrics:
%
%2D
%
%     5  for 4-connected neighbor,
%     7  for 8-connected neighbor,
%     11 for neighbors reachable with a knight's move.
%
%3D
%
%
%     4  for 6-connected neighbors,
%     6  for 18-connected neighbors,
%     7  for 26-connected neighbors,
%     9  for neighbors reachable with knight's move,
%     10 for (2,1,1) neighbors,
%     12 for (2,2,1) neighbors.
%
%
%The edge parameter specifies
%whether the border of the image should be treated as object (DIP_TRUE) or
%as background (DIP_FALSE).
%See  this section for a description of the skeleton operation.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Binary input image
%  dip_Image out     IMAGE *out     Output image
%  dip_EndpixelCondition endpixelCondition      int endpixelCondition      Endpixel condition
%  dip_Boolean edgeCondition     int edgeCondition    Edge condition
%
%The dip_EndpixelCondition enumeration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_ENDPIXEL_CONDITION_LOOSE_ENDS_AWAY    -1    Loose ends are eaten away
%  DIP_ENDPIXEL_CONDITION_NATURAL      0     "natural" endpixel condition of this algorithm
%  DIP_ENDPIXEL_CONDITION_KEEP_WITH_ONE_NEIGHBOR      1     Keep endpoint if it has a neighbor
%  DIP_ENDPIXEL_CONDITION_KEEP_WITH_TWO_NEIGHBORS     2     Keep endpoint if it has two neighbors
%  DIP_ENDPIXEL_CONDITION_KEEP_WITH_THREE_NEIGHBORS      3     Keep endpoint if it has three neighbors
%
%KNOWN BUGS
%EuclideanSkeleton() is only implemented for 2 and 3 D images.
%LITERATURE
%"Improved metrics in image processing applied to the Hilditch
%skeleton", B.J.H. Verwer, 9th ICPR, Rome, November 14-17, 1988.
%
%AUTHOR
%Ben Verwer, adapted to DIPlib by Geert van Kempen.
%SEE ALSO
% BinaryPropagation
