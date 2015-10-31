%dip_rotation3daxis   Interpolation function.
%    out = dip_rotation3daxis(in, angle, axis, method, bgval)
%
%   This function for backwards compatability only. Calls dip_rotation3d_axis,
%   which has a different definition of the axis parameter.
%
%   in
%      Image.
%   angle
%      Real number.
%   axis
%      Int [1 3], 3:z-axis, 2:y-axis, 1:x-axis
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
% Cris Luengo, October 2008.

function out = dip_rotation3daxis(in, angle, axis, method, bgval)
out = dip_rotation3d_axis(in, angle, axis-1, method, bgval);
