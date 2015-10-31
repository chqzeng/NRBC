%dipio_imagewriteics   Write colour image to file.
%    dipio_imagewriteics(in, filename, photometric, physDims, tags, sigbits, version, compression)
%
%   in
%      Image.
%   filename
%      String.
%   photometric
%      String containing one of the following values:
%      'gray', 'RGB', 'L*a*b*', 'L*u*v*', 'CMYK', 'CMY', 'XYZ', 'Yxy',
%      'HCV', 'HSV', 'R''G''B'''
%      If it is not 'gray', the last dimension in IN is considered the
%      colour channels.
%   physDims
%      Structure containing the following fields:
%        physDims.dimensions         pixel pitch (array)
%        physDims.origin             coordinates of 0th pixel (array)
%        physDims.dimensionUnits     distance units (cell array of strings)
%        physDims.intensity          grey-value gain (scalar)
%        physDims.offset             grey-value offset (scalar)
%        physDims.intensityUnit      intensity units (string)
%      Set it to [] if you don't want to bother with this.
%      The arrays must have ndims(in) dimensions, unless photometric is
%      not 'gray', in which case they can have one less element.
%   tags
%      Cell array of strings which are written to the ics history tag.
%      One line per tag (max 246 char), the keyword is 'dipIO tag' for every line.
%      Set it to {}, when leaving empty.
%   sigbits
%      Integer. Set to 0 if you don't want to bother.
%   version
%      Either 1 or 2. Version 2 creates one file, version 1 creates two
%      (an .ics header file and an .ids data file).
%   compression
%      Boolean number (1 or 0).

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2004.
