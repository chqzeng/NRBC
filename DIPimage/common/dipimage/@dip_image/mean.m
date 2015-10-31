%MEAN   Mean of all pixels in an image.
%   VALUE = MEAN(B) returns the mean intensity of all pixels in image B.
%
%   VALUE = MEAN(B,M) only computes the mean of the pixels within the
%   mask specified by the binary image M, and is equivalent to MEAN(B(M)).
%
%   VALUE = MEAN(B,M,DIM) performs the computation over the dimensions
%   specified in DIM. DIM can be an array with any number of dimensions.
%   M can be [].
%
%   If B is a tensor image, MEAN(B) is the image with the mean over all the
%   tensor components.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2001.
% 24 June 2003: Corrected help on mask parameter.
% 24 June 2011: Allowing array inputs, to match SUM and PROD. (CL)

function value = mean(in,mask,d)
if ~di_isdipimobj(in)
   error('Illegal input to overloaded function MEAN.')
elseif isscalar(in)
   nd = ndims(in);
   if nd == 0
      value = double(in);
   else
      if nargin < 2
         mask = [];
      end
      try
         if nargin < 3
            process = di_processarray(nd);
            value = double(dip_mean(in,mask,process));
         else
            process = di_processarray(nd,d);
            value = dip_mean(in,mask,process);
         end
      catch
         error(di_firsterr)
      end
   end
elseif istensor(in)
   if nargin > 1
      error('MASK and DIM parameter not supported for tensor images.')
   end
   try
      value = compute0array('plus',in);
      value = value/prod(imarsize(in));
   catch
      error(di_firsterr)
   end
else
   error('Input must be a scalar or tensor image.')
end
