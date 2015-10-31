%SUM   Sum of all pixels in an image.
%   VALUE = SUM(B) gets the value of the sum of all pixels in an image.
%
%   VALUE = SUM(B,M) only computes the sum of the pixels within the
%   mask specified by the binary image M, and is equivalent to SUM(B(M)).
%
%   VALUE = SUM(B,M,DIM) computes the sum over the dimensions specified
%   in DIM. For example, if B is a 3D image, SUM(B,[],3) returns an image
%   with 2 dimensions, containing the sum over the pixel values along
%   the third dimension (z). DIM can be an array with any number of
%   dimensions. M can be [].
%
%   If B is a tensor image, SUM(B) is the image with the sum over all the
%   tensor components.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% 6 November 2000:  Also overloaded for tensor images.
% 28 November 2000: Added DIM parameter.
% 19 April 2001:    Not using COMPUTE0 anymore.
% 27 April 2001:    Added MASK parameter.
% 24 June 2003:     Corrected help on mask parameter.
% 24 June 2011:     Not using DO1ARRAYINPUT any more. (CL)

function value = sum(in,mask,d)
if ~di_isdipimobj(in)
   error('Illegal input to overloaded function SUM.')
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
            value = double(dip_sum(in,mask,process));
         else
            process = di_processarray(nd,d);
            value = dip_sum(in,mask,process);
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
   catch
      error(di_firsterr)
   end
else
   error('Input must be a scalar or tensor image.')
end
