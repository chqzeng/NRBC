%dipio_imagereadroi   Read image ROI from file.
%    out = dipio_imagereadroi(filename, offset, roisize, sampling,
%                             format, addExtensions)
%
%   filename
%      String.
%   offset
%      Integer array.
%   roisize
%      Integer array.
%   sampling
%      Integer array.
%   format
%      File format. String containing one of the values as returned by
%      dipio_getimagereadformats. If format is an empty string,
%      different types will be tried.
%   addExtensions
%      Boolean.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2002.
