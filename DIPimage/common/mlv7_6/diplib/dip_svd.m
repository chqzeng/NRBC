%dip_svd Singular value decomposition
%    [u,s,v] = dip_svd(in)
%
%   in = u*s*v' with s diagonal matrix
%
%   in
%      2D Image Array, MxN
%   u
%      2D Image Array, MxN
%   s
%      2D Image Array, NxN (diagonal matrix)
%   v
%      2D Image Array, NxN
%
% ALTERNATIVE:
%
%    s = dip_svd(in)
%
%   s
%      1D Image Array, N 

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger October 2005
% Cris Luengo, July 2010
