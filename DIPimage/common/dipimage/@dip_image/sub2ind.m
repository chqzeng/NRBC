%SUB2IND   Linear indices from coordinates
%   I = SUB2IND(A,C) returns the linear indices in the image A that
%   correspond to coordinates C. That is,
%      A(I(N)) == A(C(N,1),C(N,2))
%
%   Note that SUB2IND(SIZE(A),C) produces different results!
%
%   See also DIP_IMAGE/IND2SUB, COORD2IMAGE, DIP_IMAGE/FIND, DIP_IMAGE/FINDCOORD.

% (C) Copyright 2010, Cris Luengo, 28 September 2010.
% Centre for Image Analysis, Uppsala, Sweden.

function I = sub2ind(in,C)
sz = imsize(in);
if any(sz==0), error('Input image is empty'), end
if size(C,2)~=length(sz), error('Array C does not match image dimensionality'), end
if any(any(C>=repmat(sz,size(C,1),1),1)) | any(any(C<0,1)), error('Found coordinates outside range.'), end
if length(sz)<=1
   I = C;
else
   strides = cumprod([1,sz([2,1,3:end])]);
   strides = strides([2,1,3:end-1])';
   I = C*strides;
end
