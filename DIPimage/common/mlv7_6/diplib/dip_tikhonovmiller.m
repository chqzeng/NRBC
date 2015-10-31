%dip_tikhonovmiller   Image restoration filter.
%    out = dip_tikhonovmiller(in, psf, reg, background, method, var, lambda, flags)
%
%   in
%      Image.
%   psf
%      Image.
%   reg
%      Image.
%   background
%      Image.
%   method
%      String containing one of the following values:
%      'manual', 'gcv', 'cls', 'snr', 'edf', 'ml', 'edf_cv', 'cls_cv',
%      'snr_cv', 'variance_cv'.
%   var
%      Real number.
%   lambda
%      Real number.
%   flags
%      String containing one of the following values:
%      'verbose', 'symmetric_psf', 'otf', 'sieve', 'normalize', 'use_inputs'.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   FUNCTION:
%The TikhonovMiller restoration filter is a linear least squares restoration
%algorithm.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image psf     IMAGE *psf     Point spread function image
%  dip_Image out     IMAGE *out     Output image
%  dip_Image reg     IMAGE *reg     Regularisation filter image
%  dip_Image background (0)      IMAGE *background    Background image
%  dipf_RegularizationParameter method    int method     Method used to determine the regularisation parameter
%  dip_float var     double var     Noise variance
%  dip_float *lambda    double *lambda    Regularisation parameter
%  dipf_ImageRestoration flags      int flags      Restoration flags
%
%LITERATURE
%G.M.P. van Kempen, Image Restoration in FLuorescence Microscopy,
%Ph.D. Thesis, Delft University of Technology, 1999
%SEE ALSO
% Wiener , TikhonovRegularizationParameter
