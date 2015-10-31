%dip_symmetriceigensystem3   Eigenvalue/-vector analysis for a sym 3x3 matrix.
%   [l1, v1, phi1, theta1, l2, v2, phi2, theta2, l3, v3, phi3, theta3, energy, ...
%    cylindrical, planar] = dip_symmetriceigensystem3(G11, G12, G13, G22, G23, ...
%    G33, desiredOutputs)
%
%   G11,G12,G13,G22,G23,G33
%      Image elements of the matrix. 
%      Must be of the same size.
%   
%   desiredOutputs
%      Cell array containing one or more of these strings:
%      'l1','v1','phi1','theta1','l2','v2','phi2','theta2','l3','v3','phi3',
%      'theta3','energy','cylindrical','planar'.
%
%   l1, v1, phi1, theta1, l2, v2, phi2, theta2, l3, v3, phi3, theta3,
%   energy, cylindrical, planar
%      Output images. 
%   v1,v2,v3 are vector images containing the eigenvectors in cartesian coordinates
%
%   The strings in DESIREDOUTPUTS can be in any order, but must not be repeated.
%   The order of the output images is as indicated here. Thus,
%      [OUT1,OUT2] = DIP_SYMMETRICEIGENSYSTEM3(IN,....,{'PLANAR','ENERGY'});
%   returns the energy image in OUT1 and the planar image in OUT2.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, Bernd Rieger Dec 2000.
