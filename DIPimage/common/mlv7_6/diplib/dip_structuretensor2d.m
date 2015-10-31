%dip_structuretensor2d   Two dimensional Structure Tensor.
%   [orientation, energy, anisotropy, l1, l2, curvature] =
%      dip_structuretensor2d(in, gradFlavour, gradSigmas,
%      tensorFlavour, tensorSigmas, curvatureFlavour, curvatureSigmas,
%      desiredOutputs)
%
%   in
%      Image.
%   gradFlavour
%      Derivative flavour. String containing one of the following values:
%      'gaussiir', 'gaussfir', 'gaussft', 'finitediff'.
%   gradSigmas
%      Real array.
%   tensorFlavour
%      Smoothing flavour. String containing one of the following values:
%      'gaussiir', 'gaussfir', 'gaussft'.
%   tensorSigmas
%      Real array.
%   curvatureFlavour
%      Derivative flavour. String containing one of the following values:
%      'gaussiir', 'gaussfir', 'gaussft', 'finitediff'.
%   curvatureSigmas
%      Real array. (Ignored unless 'curvature' output is requested.)
%   desiredOutputs
%      Cell array containing one or more of these strings:
%      'orientation', 'energy', 'anisotropy', 'l1', 'l2', 'curvature'.
%
%   orientation, energy, anisotropy, l1, l2, curvature
%      Output images.
%
%   The strings in DESIREDOUTPUTS can be in any order, but must not be repeated.
%   The order of the output images is as indicated here. Thus,
%      [OUT1,OUT2] = DIP_STRUCTURETENSOR2D(IN,....,{'L1','ORIENTATION'});
%   returns the orientation image in OUT1 and the lambda1 image in OUT2.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

