%dip_rotation_with_bgval   Interpolation function.
%    out = dip_rotation_with_bgval(in, angle, method, bgval, value)
%
%   in
%      Image.
%   angle
%      Real number.
%   method
%      Interpolation method. String containing one of the following values:
%      'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh'.
%   bgval
%      Value used to fill up the background. String containing one of the
%      following values:
%      'zero', 'min', 'max', 'manual'.
%   value
%      For bval = 'manual' a float value can be given.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, December 2008

%This function rotates an 2-D image in over angle to out using three skews.
%The function implements the rotation in the mathmetical sense, but note
%the Y-axis is positive downwards! The rotation is over the centre of the image.
