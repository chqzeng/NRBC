%   HYSTERESISTHRESHOLD  Hysteresis thresholding.
%   out = hysteresisthreshold(in, low, high)
% 
%   Performs hysteresis thresholding. From the binary 
%   image (in>low) only those regions are selected for which 
%   at least one location also has (in>high)
% 
%   in
%      Image.
%   low
%      lower threshold value.
%   high
%      higher threshold value.
%   out
%      binary image
% 
%   Example:
%   low = 150;
%   high = 200;
%   a = readim('unsharp.ics') % read a test image
%   b = a>low
%   c = a>high
%   d = dip_hysteresisthreshold(a, low, high)
% 
%   See also: THRESHOLD, DIP_RANGETHRESHOLD 

% (C) Copyright 1999-2004               Quantitative Imaging Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
% 
% Kees van Wijk januari 2004.
