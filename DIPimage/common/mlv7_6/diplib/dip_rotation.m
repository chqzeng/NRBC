%dip_rotation   Interpolation function.
%    out = dip_rotation(in, angle, method, bgval)
%
%   in
%      Image.
%   angle
%      Real number.
%   method
%      Interpolation method. String containing one of the following values:
%      'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh',
%      'lanczos2', 'lanczos3', 'lanczos4', 'lanczos6', 'lanczos8'.
%   bgval
%      Value used to fill up the background. String containing one of the
%      following values:
%      'zero', 'min', 'max'.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%binary, integer, float
%FUNCTION
%This function rotates an 2-D image in over angle to out using three skews.
%The function implements the rotation in the mathmetical sense, but note
%the Y-axis is positive downwards! The rotation is over the centre of the image.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float angle (radians)     double angle (degrees)     Rotation angle
%  dipf_Interpolation method     int method     Interpolation method
%
%The dipf_Interpolation enumaration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_INTERPOLATION_DEFAULT     ITP_DEFAULT    Default interpolation method
%  DIP_INTERPOLATION_BSPLINE     ITP_BSPLINE    B-Spline interpolation
%  DIP_INTERPOLATION_FOURTH_ORDER_CUBIC      ITP_FOURTH_ORDER_CUBIC     Forth order cubic interpolation
%  DIP_INTERPOLATION_THIRD_ORDER_CUBIC    ITP_THIRD_ORDER_CUBIC      Third order cubic interpolation
%  DIP_INTERPOLATION_LINEAR    ITP_BILINEAR      Linear interpolation
%  DIP_INTERPOLATION_ZERO_ORDER_HOLD      ITP_ZERO_ORDER_HOLD     Zero order hold interpolation
%
%KNOWN BUGS
%This function is only implemented for 2D images.
%SEE ALSO
%Skewing
