%dip_structureadaptivegauss   Structure Adaptive Gaussian Filter.
%    out = dip_structureadaptivegauss(in, params, order, truncation, exponent, method)
%
%   in
%      Image.
%   params = newimar(phi, sigmau, [sigmav], [curv])
%      VectorImage containing the orientation, directional sigmas |- and || with 
%		orientation, curvature. Only support 2D image at the moment. 
%		parameters between [] are optional  
%   order
%      Integer array.
%   truncation
%      Integer.
%   exponent
%      Integer array.
%   method
%      interpolation method: 'bspline', 'linear', 'zoh'
%
%   All images must be sfloat.



% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham,April 2004.
