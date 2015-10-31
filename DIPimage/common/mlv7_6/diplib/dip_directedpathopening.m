%dip_directedpathopening   Path opening in a specific direction.
%    out = dip_directedpathopening(in, mask, filterparam, closing, constrained)
%
%   in
%      Image.
%   mask
%      Mask image.
%   filterParam
%      Float array.
%   closing
%      1 for the closing operation, 0 for the opening operation.
%   constrained
%      1 for constrained lines, 0 for the original path opening algorithm.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2008, May 2009.
