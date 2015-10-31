%dip_linefit   Robust line fit of a 2D point set 
%    p = dip_linefit(x, y, [iter])
%
%   x, y
%      Double array of coordinates
%   iters
%      Number of iterations for fit refinement [Optional]
%   p
%      The fitted line, i.e. y = p(1)*x + p(2)

% The algorithm is as follows:
%  1. Init a fit by leastsquare regression after removing pixels
%     with x or y coordinate outside the central 80% percentile
%  2. For every pixel: compute orthogonal distance to the line,
%     reject pixels with distances outside 3 standard deviation 
%  3. Compute new fit after outlier rejection. Then go to step 2.
%
% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, June 2004.
