%STD   Standard deviation of all pixels in an image.
%   VALUE = STD(B) returns the standard deviation of all pixels in
%   image B.
%
%   VALUE = STD(B,M), with M a binary image, is the same as STD(B(M)).
%
%   VALUE = STD(B,M,DIM) performs the computation over the dimensions
%   specified in DIM. DIM can be an array with any number of
%   dimensions. M can be [].

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2001.

function value = std(in,mask,d)
if ~isscalar(in), error('Parameter "in" is an array of images.'), end
nd = ndims(in);
if nd == 0
   error('Cannot compute STD on 0-D image.')
else
   if nargin < 2
      mask = [];
   end
   try
      if nargin == 3
         process = di_processarray(nd,d);
         value = dip_standarddeviation(in,mask,process);
      else
         process = di_processarray(nd);
         value = double(dip_standarddeviation(in,mask,process));
      end
   catch
      error(di_firsterr)
   end
end
