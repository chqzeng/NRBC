%dipio_imagewrite   Write image to file.
%    dipio_imagewrite(in, filename, physDims, format, compression)
%
%   in
%      Image.
%   filename
%      String.
%   physDims
%      Physical dimensions structure. Can be [].
%   format
%      File format. String containing one of the values as returned by
%      dipio_getimagewriteformats.
%   compression
%      String. Empty string to use default compression method for file format.
%      Otherwise one of:
%      'none','ZIP','GZIP','LZW','Compress','PackBits','Thunderscan','NEXT',
%      'CCITTRLE','CCITTRLEW','CCITTFAX3','CCITTFAX4','deflate','JPEG'.

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo,June 2000.
