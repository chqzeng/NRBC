%dip_rotation3d   Interpolation function.
%    out = dip_rotation3d(in, alpha, beta, gamma, method, bgval)
%
%   in
%      Image.
%   alpha, beta, gamma
%      Real number.
%   method
%      Interpolation method. String containing one of the following values:
%      'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh'.
%   bgval
%      Value used to fill up the background. String containing one of the
%      following values:
%      'zero', 'min', 'max'.
%
%   Rotation in 3D by the  3 Euler angles
%   R= R_{3''}(\gamma) R_{2'}(\beta) R}_3(\alpha)

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2001


