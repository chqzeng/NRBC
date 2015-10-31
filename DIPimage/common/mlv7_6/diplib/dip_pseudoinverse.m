%dip_pseudoinverse   Image restoration filter.
%    out = dip_pseudoinverse(in, psf, threshold, flags)
%
%   in
%      Image.
%   psf
%      Image.
%   threshold
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
%This function performs a basic, very noise sensitive image restoration
%operation by inverse filtering the image with a clipped point spread function.
%Each frequency in the output for which the response of the PSF is smaller than
%threshold is set to zero.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image psf     IMAGE *psf     Point spread function image
%  dip_Image out     IMAGE *out     Output image
%  dip_float threshold     double threshold     Threshold value
%  dipf_Restoration flags     int flags      Restoration flags
%
%LITERATURE
%G.M.P. van Kempen, Image Restoration in FLuorescence Microscopy,
%Ph.D. Thesis, Delft University of Technology, 1999
%SEE ALSO
% this section in the FIP
%
% Wiener , TikhonovMiller
