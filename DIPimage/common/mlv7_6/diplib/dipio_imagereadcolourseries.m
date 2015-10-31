%dipio_imagereadcolour   Read colour image from file.
%    [out,photometric] = dipio_imagereadcolour(filename, format, addExtensions)
%
%   filename
%      String.
%   format
%      File format. String containing one of the values as returned by
%      dipio_getimagereadformats. If format is an empty string,
%      different types will be tried.
%   addExtensions
%      Boolean.
%
%   photometric
%      String containing one of the following values:
%      'gray', 'RGB', 'L*a*b*', 'L*u*v*', 'CMYK', 'CMY', 'XYZ', 'Yxy',
%      'HCV', 'HSV', 'R''G''B'''

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2002.
