%dip_orientationspace   .
%    out = dip_orientationspace(in, order, noo, phi0, dphiPar, radCentre,...
%          radSigma, pixelDims, flags)
%
%   in
%      Image.
%   order
%      Integer number.
%   noo
%      Integer number.
%   phi0
%      Real number.
%   dphiPar
%      Real number.
%   radCentre
%      Real number.
%   radSigma
%      Real number.
%   pixelDims
%      Array with two real numbers.
%   flags
%      Cell array containing some of: 'slices_normal', 'slices_explicit',
%      'slices_critical', 'angular_gauss', 'angular_psinc',  'angular_one',
%      'angular_cos', 'use_deltha_phi', 'radial_one', 'spatial'
%
% For normal use, use: {'slices_normal','angular_gauss','spatial'}

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel  December 2000.
