%CIRCSHIFT   Shift image circularly.
%   B = CIRCSHIFT(A,N) shifts the image by N(D) in each dimension D.
%   N must be an array with integer values, and contain one value
%   per image dimension. Positive shifts are to the right or down,
%   negative shifts the other way. The image is assumed to have
%   periodic boundary conditions.
%
%   See also SHIFT, RESAMPLE, DIP_IMAGE/RESHAPE, DIP_IMAGE/SHIFTDIM,
%   DIP_IMAGE/PERMUTE

% (C) Copyright 2010-2011, Cris Luengo (30 September 2010)
% Centre for Image Analysis, Uppsala, Sweden.
%
% 27 June 2011:  Now works on image arrays.

function in = circshift(in,n)
if nargin~=2, error('2nd input argument expected.'); end
for ii=1:imarsize(in)
   nd = in(ii).dims;
   if prod(size(n))~=nd
      error('Input argument N needs as many elements as image dimensions.')
   end
   if nd==1
      k = [0,n]; % 1D images are always stored as a horizontal vector
   else
      k = n([2,1,3:end]); % Swap 1st and 2nd dims
   end
   in(ii).data = circshift(in(ii).data,k);
end
