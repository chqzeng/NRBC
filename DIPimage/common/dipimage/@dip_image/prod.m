%PROD Product of elements.
%   VALUE = PROD(B) gets the value of the product of all pixels in an image.
%
%   VALUE = PROD(B,M) only computes the product of the pixels within the
%   mask specified by the binary image M, and is equivalent to PROD(B(M)).
%
%   VALUE = PROD(B,M,DIM) computes the product over the dimensions specified
%   in DIM. For example, if B is a 3D image, PROD(B,[],3) returns an image
%   with 2 dimensions, containing the product over the pixel values along
%   the third dimension (z). DIM can be an array with any number of
%   dimensions. M can be [].
%
%   If B is a tensor image, PROD(B) is the image with the product over all
%   the tensor components.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2005.
% 24 June 2011: Not using DO1ARRAYINPUT any more. (CL)

function value = prod(in,mask,d)
if ~di_isdipimobj(in)
   error('Illegal input to overloaded function PROD.')
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
            value = double(dip_prod(in,mask,process));
         else
            process = di_processarray(nd,d);
            value = dip_prod(in,mask,process);
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
      value = compute0array('times',in);
   catch
      error(di_firsterr)
   end
else
   error('Input must be a scalar or tensor image.')
end
