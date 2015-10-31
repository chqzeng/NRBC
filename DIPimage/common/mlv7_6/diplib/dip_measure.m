%dip_measure   Measure stuff in a labeled image.
%    data = dip_measure(objectimage, intensityimage, measurements,...
%           objects, connectivity)
%
%   objectimage
%      Labeled image (result from dip_label).
%   intensityimage
%      Grayvalue image (can be empty, depending on required measurements).
%   measurements
%      What to measure. Cell array containing some strings. The list
%      can be obtained by calling DIP_GETMEASUREFEATURES.
%   objects
%      Integer array. Which objects to measure.
%   connectivity
%      Integer number. Only used whith some measurement functions.
%         number <= dimensions of in
%         pixels to consider connected at distance sqrt(number)
%
%   data
%      Output object containing the measured vales.
%
%   When MEASUREMENTS is an empty array, this function returns an array containing
%   only object IDs.
%
%   If the OBJECTS array is empty, the measurement is performed on all objects.

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
