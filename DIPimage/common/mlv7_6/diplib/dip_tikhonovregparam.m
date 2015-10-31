%dip_tikhonovregparam   Determine the value of the regularisation parameter.
%    out = dip_tikhonovregparam(in, psf, reg, background, max, min, lambda,...
%          method, var, flags)
%
%   in
%      Image.
%   psf
%      Image.
%   reg
%      Image.
%   background
%      Image.
%   max
%      Real number.
%   min
%      Real number.
%   lambda
%      Real number.
%   method
%      String containing one of the following values:
%      'manual', 'gcv', 'cls', 'snr', 'edf', 'ml', 'edf_cv', 'cls_cv',
%      'snr_cv', 'variance_cv'.
%   var
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
%Thios function implements different methods to estimate the value of the
%regularistion parameter lambda of the TikhonovMiller restoration filter.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image psf     IMAGE *psf     Point spread function image
%  dip_Image reg     IMAGE *reg     Regularisation filter rimage
%  dip_Image background (0)      IMAGE *background    Background image
%  dip_float max     double max     Maximum value of lambda
%  dip_float min     double min     Minimum value of lambda
%  dip_float *lambda    double *lambda    pointer to the regularisation parameter
%  dipf_RegularizationParameter method    int method     Method used to determine lambda
%  dip_float var     double var     Noise variance
%  dipf_ImageRestoration flags      int flags      Restoration flags
%
%LITERATURE
%G.M.P. van Kempen, Image Restoration in FLuorescence Microscopy,
%Ph.D. Thesis, Delft University of Technology, 1999
%SEE ALSO
% TikhonovRegularizationParameter
