%dip_resampling   Interpolation function.
%    out = dip_resampling(in, zoom, shift, method)
%
%   in
%      Image.
%   zoom
%      Real array.
%   shift
%      Real array.
%   method
%      Interpolation method. String containing one of the following values:
%      'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh',
%      'lanczos2', 'lanczos3', 'lanczos4', 'lanczos6', 'lanczos8'.

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
%This function resmaples the input image in to out using various interpolation
%methods. Both a (subpixel) shift and a zoom factor are supported. The size
%of the output image is zoom times the size of in. If shift is zero, a
%shift of zero is assumed. If zoom is zero, a zoom of 1.0 is assumed.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_FloatArray zoom     FloatArray zoom      Zoom factor
%  dip_FloatArray shift    FloatArray shift     Shift
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
% Subsampling
