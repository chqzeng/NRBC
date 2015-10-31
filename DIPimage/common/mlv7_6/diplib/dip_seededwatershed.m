%dip_seededwatershed   Watershed initialised with custom seeds.
%    out = dip_seededwatershed(seed, grey, mask, connectivity, order, max_depth, max_size, binaryOutput)
%
%   seed
%      Label or binary image.
%   grey
%      Grey-value image.
%   mask
%      Mask image.
%   connectivity
%      Integer number (1 to n, for nD image).
%   order
%      String containing one of the following values:
%      'low_first', 'high_first'
%   max_depth
%      Real number: a region of this depth or less can be merged.
%   max_size
%      Integer number. a region of this size or less can be merged.
%   binaryOutput
%      Boolean number (1 or 0).

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2008.
