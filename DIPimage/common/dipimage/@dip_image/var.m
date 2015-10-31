%VAR   Variance of all pixels in an image.
%   VALUE = VAR(B) returns the standard deviation of all pixels in
%   image B.
%
%   VALUE = VAR(B,M), with M a binary image, is the same as VAR(B(M)).
%
%   VALUE = VAR(B,M,DIM) performs the computation over the dimensions
%   specified in DIM. DIM can be an array with any number of
%   dimensions. M can be [].

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2001.

function value = var(in,mask,d)
if ~isscalar(in), error('Parameter "in" is an array of images.'), end
nd = ndims(in);
if nd == 0
   error('Cannot compute VAR on 0-D image.')
else
   if nargin < 2
      mask = [];
   end
   try
      if nargin == 3
         process = di_processarray(nd,d);
         value = dip_standarddeviation(in,mask,process)^2;
      else
         process = di_processarray(nd);
         value = double(dip_standarddeviation(in,mask,process))^2;
      end
   catch
      error(di_firsterr)
   end
end
