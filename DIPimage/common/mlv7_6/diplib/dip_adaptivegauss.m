%dip_adaptivegauss   Adaptive Gaussian Filter.
%    out = dip_adaptivegauss(in, orientation, sigmas, order, truncation)
%
%   in
%      Image.
%   orientation
%      VectorImage containing the orientation. 
%      2D: one parameter image, angle of the orientation
%      3D: 2 or 4 parameter images for intrinsic 1/2D filtering
%          v{1} = phi2, v{2} = theta2, v{3} = phi3, v{4} = theta3
%   sigmas
%      Real array.
%   order
%      Integer array.
%   truncation
%      Integer.
%   exponent
%      Integer array.
%
%   All images must be sfloat.



% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger,February 2002.
