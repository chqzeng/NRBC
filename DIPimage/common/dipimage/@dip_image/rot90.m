%ROT90  Rotate image 90 degrees.
%   ROT90(A) is the 90 degree counterclockwise rotation of image A.
%   ROT90(A,K) is the K*90 degree rotation of A, K = +-1,+-2,...

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% 23 February 2006: Rotating tensor images as well.
% 26 July 2007:     Working on images of more than 2 dimensions as well.
% February 2008:    Adding pixel dimensions and units to dip_image. (BR)
% 27 June 2011:     Now also works with any image array. (CL)
% 22 November 2013: Allowing physDims to be empty. (CL)

function b = rot90(b,k)
if nargin == 1
    k = 1;
else
   if ~isnumeric(k) | length(k)~=1 | fix(k)~=k
      error('k must be a scalar.');
   end
   k = mod(k,4);
end
for ii=1:prod(imarsize(b))
   if b(ii).dims < 2
      error('Cannot rotate with less than two dimensions.')
   end
end
if k == 1
   for ii=1:prod(imarsize(b))
      p = [2,1,3:b(ii).dims];
      b(ii).data = flipdim(permute(b(ii).data,p),1);
      if ~isempty(b(ii).physDims.PixelSize)
         b(ii).physDims.PixelSize  = b(ii).physDims.PixelSize([2,1,3:end]);
      end
      if ~isempty(b(ii).physDims.PixelUnits)
         b(ii).physDims.PixelUnits = b(ii).physDims.PixelUnits([2,1,3:end]);
      end
   end
elseif k == 2
   for ii=1:prod(imarsize(b))
      b(ii).data = flipdim(flipdim(b(ii).data,1),2);
      % physDims stay the same for pi rotations
   end
elseif k == 3
   for ii=1:prod(imarsize(b))
      p = [2,1,3:b(ii).dims];
      b(ii).data = flipdim(permute(b(ii).data,p),2);
      if ~isempty(b(ii).physDims.PixelSize)
         b(ii).physDims.PixelSize  = b(ii).physDims.PixelSize([2,1,3:end]);
      end
      if ~isempty(b(ii).physDims.PixelUnits)
         b(ii).physDims.PixelUnits = b(ii).physDims.PixelUnits([2,1,3:end]);
      end
   end
% else k==0, we do nothing.
end
