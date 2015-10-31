%dip_convolve1d   1D convolution filter.
%    out = dip_convolve1d(in, filter, dimension, origin)
%
%   in
%      Image.
%   filter
%      Float array. Filter values.
%   dimension
%      Integer. Image dimension to filter along [0..N-1].
%   origin
%      Integer or []. Index of origin within filter array. If [], and
%      filter is odd in length, the middle pixel is the origin. If [],
%      and the filter is even in length, the pixel to the right of the
%      middle is the origin.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2008
% Centre for Image Analysis, Uppsala, Sweden
