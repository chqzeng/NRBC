%dip_wiener   Image Restoration Filter.
%    out = dip_wiener(in, psf, signalPower, noisePower, flags)
%
%   in
%      Image.
%   psf
%      Image.
%   signalPower
%      Image.
%   noisePower
%      Image.
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
%This function performs an image restoration using the Wiener filter. The Wiener
%filter is the linear restoration filter that is optimal in mean square error
%sense.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image psf     IMAGE *psf     Point spread function image
%  dip_Image signalPower      IMAGE *signalPower      SignalPower image
%  dip_Image noisePower    IMAGE *noisePower    NoisePower image
%  dip_Image out     IMAGE *out     Output image
%  dipf_Restoration flags     int flags      Restoration flags
%
%LITERATURE
%G.M.P. van Kempen, Image Restoration in FLuorescence Microscopy,
%Ph.D. Thesis, Delft University of Technology, 1999
%SEE ALSO
% this section in the FIP
%
% PseudoInverse , TikhonovMiller
