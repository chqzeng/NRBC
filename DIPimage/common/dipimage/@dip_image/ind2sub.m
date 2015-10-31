%IND2SUB   Coordinates from linear indices.
%   C = IND2SUB(A,I) returns the coordinates in the image A that
%   correspond to linear indices I. That is,
%      A(C(N,1),C(N,2)) == A(I(N))
%
%   Note that IND2SUB(SIZE(A),I) produces different results!
%
%   See also DIP_IMAGE/SUB2IND, COORD2IMAGE, DIP_IMAGE/FIND, DIP_IMAGE/FINDCOORD.

% (C) Copyright 2010, Cris Luengo, 28 September 2010.
% Centre for Image Analysis, Uppsala, Sweden.

function C = ind2sub(in,I)
sz = imsize(in);
if any(sz==0), error('Input image is empty'), end
I = I(:);
m = prod(sz)-1;
if any(I>m) | any(I<0), error('Found indices outside range.'), end
if length(sz)<=1
   C = I;
else
   C = zeros(length(I),length(sz));
   k = [1,cumprod(sz([2,1,3:end-1]))];
   for ii=length(sz):-1:2
      C(:,ii) = floor(I/k(ii));
      I = I-(C(:,ii)*k(ii));
   end
   C(:,1) = C(:,2); % Switch the X and Y coordinates!
   C(:,2) = I;
end
