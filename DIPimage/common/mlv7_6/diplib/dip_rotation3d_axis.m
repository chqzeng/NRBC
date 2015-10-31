%dip_rotation3d_axis   Interpolation function.
%    out = dip_rotation3d_axis(in, angle, axis, method, bgval)
%
%   in
%      Image.
%   angle
%      Real number.
%   axis
%      Int [0 2], 2:z-axis, 1:y-axis, 0:x-axis
%   method
%      Interpolation method. String containing one of the following values:
%      'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh'.
%   bgval
%      Value used to fill up the background. String containing one of the
%      following values:
%      'zero', 'min', 'max'.
%

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2001
