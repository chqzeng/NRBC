%dip_imagechaincode   Obtain the chain codes for the objects in the image
%    data = dip_imagechaincode(objectimage, connectivity, objects)
%
%   objectimage
%      Labeled image (result from dip_label). Only 2D images supported
%   connectivity
%      Integer number (1 or 2).
%      Pixels to consider connected at distance sqrt(connectivity)
%   objects
%      Integer array. Which objects to measure. If [] is given,
%      uses all the objects in objectimage.
%
%   data
%      Output struct array containing the chain codes values.
%      If has the following fields:
%        label          ID of object
%        connectivity   Value of the connectivity parameter
%        start          [x,y] coordinates of first pixel in chain
%        chain          Array with chain codes
%        border         Array with non-zero where the pixel is at the
%                       image border.
%      For each object only one chain is produced. If the border
%      of the object is not continuous, the chain code will not
%      represent the whole object.
%      The chain has one more element than there are border pixels.
%      The first element in the chain is always 0.

% (C) Copyright 1999-2009, All rights reserved
%
% Cris Luengo, July 2009.
