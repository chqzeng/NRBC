%dip_separableconvolution   Separable convolution filter.
%   out = dip_separableconvolution(in, filters, process)
%
%   in
%      Image.
%   filters
%      struct array, see below.
%   process
%      Boolean array.
%
%   filters contains the following elements:
%     filters(ii).filter
%        The filter kernel, double 1xN or Nx1 array.
%     filters(ii).origin
%        Position of the origin of the filter (0 = leftmost pixel is
%        the orign, N = rightmost pixel, etc.). This is optional, and
%        is automatically computed if not given.
%     filters(ii).flags
%        One or more of the following flags (put them in a cell array
%        to give more than one flag):
%           'left'
%           'right'
%           'even': if the filter is even
%           'odd':  if the filter is odd
%
%   'even' and 'odd' are mutually exclusive. If neither is given,
%   a non-symmetric filter kernel is assumed.
%
%   The filter kernel origin, if not explicitly given, is assumed to
%   be the middle pixel if odd in size, or, if the filter is even in
%   size, either the pixel to the left or right of the middle,
%   depending on which of the flags 'left' or 'right' is given. If
%   neither is given, 'right' is assumed. For example:
%
%        x x x x x    ('left'/'right' flags ignored)
%            ^
%
%        x x x x x x  ('left' specified)
%            ^
%
%        x x x x x x  ('right' specified)
%              ^
%
%        x x x x x x  (origin=1 specified, 'left'/'right' flags ignored)
%          ^
%
%   If process(ii)==0, filters(ii) is ignored. Filters and process should
%   have one element for each image dimension. Process can be [], in which
%   case it is assumed to be 1 for every dimension. Process is forced to
%   0 for those dimensions where the image has size==1 (singleton
%   dimensions).

% (C) Copyright 2010, Cris Luengo.
