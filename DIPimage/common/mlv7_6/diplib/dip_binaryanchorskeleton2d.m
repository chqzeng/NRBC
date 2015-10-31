%dip_binaryanchorskeleton2d   binary skeleton operation.
%   out = dip_binaryanchorskeleton2d(in,anchor,iterations,edgeCondition,endCondition)
%
%   This function is defined for 2D images only
%
%   in
%      binary image
%   anchor
%      binary image with anchor points
%   iterations
%      number of iterations
%   edgeCondition
%      edge belongs to anchor or not: 1 or 0 
%   endCondition
%      (0 or 1) similar to 'looseendsaway' and 'natural'

% (C) Copyright 2005                    Quantitative Imaging Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Frank Faas, June 2005
