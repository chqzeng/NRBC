%dip_binaryskeleton3d   binary skeleton operation.
%   out = dip_binaryskeleton3d(in, endpixelCondition, edgeCondition)
%
%   This function is defined for 3D images only, as a substitute to the
%   poor performance of dip_euclideanskeleton for 3D images.
%
%   in
%      Image.
%   endpixelCondition
%      End pixel condition. String containing one of the following values:
%      'looseendsaway', 'natural', '1neighbor', '2neighbors', '3neighbors'.
%   edgeCondition
%      Boolean number (1 or 0).

% (C) Copyright 2005                    Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, Janury 2005
