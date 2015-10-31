%dip_paircorrelation   .
%    out = dip_paircorrelation(image, mask, probes, length, estimator, covariance, normalisation)
%
%   image
%      Image.
%   mask
%      Mask image. Can be [] for no mask.
%   probes
%      Integer number.
%   length
%      Integer number.
%   estimator
%      String containing either 'random' or 'grid'.
%   covariance
%      Boolean number (1 or 0)
%   normalisation
%      String containing 'none', 'volume_fraction' or 'volume_fraction^2'

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Geert van Kempen, Unilever Research Vlaardingen, June 2001.

