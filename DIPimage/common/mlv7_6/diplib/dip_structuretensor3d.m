%dip_structuretensor3d   Three dimensional Structure Tensor.
%   [l1, phi1, theta1, l2, phi2, theta2, l3, phi3, theta3, energy, ...
%      cylindrical, planar] = dip_structuretensor3d(in, gradFlavour, ...
%      gradSigmas, tensorFlavour, tensorSigmas, desiredOutputs)
%
%   in
%      Image.
%   gradFlavour
%      Derivative flavour. String containing one of the following values:
%      'gaussiir', 'gaussfir', 'gaussft', 'finitediff'.
%   gradSigmas
%      Real array.
%   tensorFlavour
%      Derivative flavour. String containing one of the following values:
%      'gaussiir', 'gaussfir', 'gaussft', 'finitediff'.
%   tensorSigmas
%      Real array.
%   desiredOutputs
%      Cell array containing one or more of these strings:
%      'l1','phi1','theta1','l2','phi2','theta2','l3','phi3','theta3',
%      'energy','cylindrical','planar'.
%
%   l1, phi1, theta1, l2, phi2, theta2, l3, phi3, theta3,
%   energy, cylindrical, planar
%      Output images.
%
%   The strings in DESIREDOUTPUTS can be in any order, but must not be repeated.
%   The order of the output images is as indicated here. Thus,
%      [OUT1,OUT2] = DIP_STRUCTURETENSOR3D(IN,....,{'PLANAR','ENERGY'});
%   returns the energy image in OUT1 and the planar image in OUT2.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

