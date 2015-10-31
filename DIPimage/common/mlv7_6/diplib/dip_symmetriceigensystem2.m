%dip_symmetriceigensystem2   Eigenvalue/-vector analysis for a sym 2x2 matrix.
%   [l1, v1, phi1, l2, v2, phi2, energy, anisotropy] = ...
%      dip_symmetriceigensystem2(G11, G12, G22, desiredOutputs)
%
%   G11,G12,G22
%      Image elements of the matrix.
%      Must be of the same size.
%
%   desiredOutputs
%      Cell array containing one or more of these strings:
%      'l1','v1','phi1','l2','v2','phi2','energy','anisotropy'
%
%   l1, v1, phi1, l2, v2, phi2, energy, anisotropy
%      Output images.
%   v1,v2 are vector images containing the eigenvectors in cartesian coordinates
%
%   The strings in DESIREDOUTPUTS can be in any order, but must not be repeated.
%   The order of the output images is as indicated here. Thus,
%      [OUT1,OUT2] = DIP_SYMMETRICEIGENSYSTEM2(IN,....,{'ANISOTROPY','ENERGY'});
%   returns the energy image in OUT1 and the anisotropy image in OUT2.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2002.
