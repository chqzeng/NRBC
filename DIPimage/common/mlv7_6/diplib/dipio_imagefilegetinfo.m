%dipio_imagefilegetinfo   Get information about image from file.
%    out = dipio_imagefilegetinfo(filename, format, addExtensions)
%
%   filename
%      String.
%   format
%      File format. String containing one of the values as returned by
%      dipio_getimagereadformats. If format is an empty string,
%      different types will be tried.
%   addExtensions
%      Boolean.
%   out
%      Structure containing the relevant information:
%        out.filename
%        out.filetype
%        out.size
%        out.datatype
%        out.photometric                 photometric interpretation (==colorspace)
%        out.physDims.dimensions         pixel pitch
%        out.physDims.origin             coordinates of 0th pixel
%        out.physDims.dimensionUnits     distance units
%        out.physDims.intensity          grey-value gain
%        out.physDims.offset             grey-value offset
%        out.physDims.intensityUnit      intensity units
%        out.numberOfImages              number of images if TIFF file, 1 otherwise
%        out.sigbits                     
%        out.history                     cell array of history tags

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2004.
