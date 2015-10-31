%dip_skewing   Interpolation function.
%    out = dip_skewing(in, shear, skew, axis, method, bgval, periodicSkew)
%
%   in
%      Image.
%   shear
%      Real number.
%   skew
%      Integer number.
%   axis
%      Integer number.
%   method
%      Interpolation method. String containing one of the following values:
%      'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh',
%      'lanczos2', 'lanczos3', 'lanczos4', 'lanczos6', 'lanczos8'.
%   bgval
%      Value used to fill up the background. String containing one of the
%      following values:
%      'zero', 'min', 'max'.
%   periodicSkew
%      Boolean. If set to true, 'bgval' is not used, and the output image
%      is of the same size as the input. The part of the image that exits the
%      image at one end enters at the other.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2000.

%   DATATYPES:
%binary, integer, float
%FUNCTION
%This function skews the axis axis of in over an angle angle to out using
%the interpolation method method. The skew is over the centre of the image.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float shear (radians)     double shear (degrees)     Shear angle
%  dip_int skew      int skew    Skew dimension
%  dip_int axis      int axis    Skew axis
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
%SEE ALSO
% Rotation
