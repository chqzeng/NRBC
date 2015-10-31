%dipio_imagereadtiff   Read TIFF image from file.
%    [out,photometric] = dipio_imagereadtiff(filename, imageNumber)
%
%   filename
%      String. Full file name, include file name extension.
%   imageNumber
%      Integer. Directory index to read. 0 is the first image in the file.
%
%   photometric
%      String containing one of the following values:
%      'gray', 'RGB', 'L*a*b*', 'L*u*v*', 'CMYK', 'CMY', 'XYZ', 'Yxy',
%      'HCV', 'HSV', 'R''G''B'''
%
%   NOTE:
%   Use DIPIO_IMAGEFILEGETINFO to get the number of images in the TIFF file.

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2004.
