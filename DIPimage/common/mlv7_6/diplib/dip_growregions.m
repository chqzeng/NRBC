%dip_growregions   Grow regions in a labelled image
%    out = dip_growregions(lab, grey, mask, connectivity, ...
%          iterations, order)
%
%   lab
%      Image.
%   grey
%      Image or [].
%   mask
%      Binary image or [].
%   connectivity
%      Integer number.
%         number <= dimensions of in
%         pixels to consider connected at distance sqrt(number)
%   iterations
%      Integer number.
%   order
%      String containing one of the following values:
%      'low_first', 'high_first'

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2004.
