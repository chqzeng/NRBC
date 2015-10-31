%dip_resampleat   Interpolation at irregular pixel positions. (<=3D only)
%    out = dip_resampleat(in, pos, method, fillvalue)
%
%   in
%      Image.
%   pos
%      Image array of x, y, z positions.
%   method
%      Interpolation method. String containing one of the following values:
%      'default', 'bspline', 'linear'. (default = 'linear')
%   fillvalue
%      value to be filled in case coordinate out of bound (default = 0).

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, February 2004.
