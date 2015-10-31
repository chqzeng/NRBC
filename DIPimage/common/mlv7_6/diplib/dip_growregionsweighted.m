%dip_growregionsweighted   Grow regions in a labelled image
%    [out,distance] = dip_growregionsweighted(lab, grey, mask, pixelsize, ...
%          chamfer, metric)
%
%   lab
%      Binary or label image.
%   grey
%      Image.
%   mask
%      Binary image or [].
%   pixelsize
%      Integer array or []. Only used if chamfer~=0.
%   chamfer
%      0, 3 or 5.
%   metric
%      Image. Only used if chamfer==0.

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February 2005.
