%dip_upperenvelope   Construct an upper-envelope for an image.
%    [out, bottom] = dip_upperenvelope(in, connectivity, max_depth, max_size)
%
%   in
%      Image.
%   connectivity
%      Integer number (1 to n, for nD image).
%   max_depth
%      Real number.
%   max_size
%      Integer number.
%
%   bottom
%      Image with bottom values that can be used to stretch the result:
%      (out-in)/(out-bottom)

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2001.
