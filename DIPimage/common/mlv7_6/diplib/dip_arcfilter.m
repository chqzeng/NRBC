%dip_arcfilter   xy-separable bilateral filter 
%    out = dip_arcfilter(in, params, tonalSigma, truncation, method)
%
%   in
%      Input image.
%   param
%      Image array: {orientation,sigma,[curv],[initial_estimate]}
%   tonalSigma
%      Real number.
%   truncation
%      real number.
%   method
%      string, either 'linear' or 'bspline'

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.
