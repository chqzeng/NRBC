%dip_adaptivebanana   Adaptive Gaussian Filter in banana neighborhood.
%    out = dip_adaptivebanana(in, orien, curv, sigmas, order, truncation)
%
%   in
%      Image.
%   orien
%      VectorImage containing the orientation. 
%      2D: one parameter image, angle of the orientation
%   curv
%      VectorImage containg the curvature
%   sigmas
%      Real array.
%   order
%      Integer array.
%   truncation
%      Integer.
%   exponent 
%      Inter array.
%
%   All images must be sfloat.



% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2002.
