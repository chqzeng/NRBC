%DIAG   Diagonal matrices and diagonals of a matrix.
%   DIAG(V,K) when V is a vector image with N components is a square
%   tensor image of order N+ABS(K) with the elements of V on the K-th
%   diagonal. K = 0 is the main diagonal, K > 0 is above the main
%   diagonal and K < 0 is below the main diagonal. 
% 
%   DIAG(X,K) when X is a tensor image is a column vector image formed
%   from the elements of the K-th diagonal of X.
% 
%   K defaults to 0 (the main diagonal) in both cases.

% (C) Copyright 2010, Cris Luengo (1 October 2010)
% Centre for Image Analysis, Uppsala, Sweden.

function out = diag(in,k)

if ~istensor(in)
   error('Image is not a tensor image');
end
s = imarsize(in);
if length(s)~=2
   error('Only implemented for 2D tensors.');
end

if nargin<2
   k = 0;
end

if isvector(in)
   s = max(s);
   out = dip_image('array',[s,s]+abs(k));
   out(:) = dip_image('zeros',imsize(in),'single');
   if k>=0
      for ii=1:s
         out(ii,ii+k) = in(ii);
      end
   else
      for ii=1:s
         out(ii-k,ii) = in(ii);
      end
   end
else
   s = min(s)-abs(k);
   if s<=0
      error('K out of bounds.');
   end
   out = dip_image('array',[s,1]);
   if k>=0
      for ii=1:s
         out(ii) = in(ii,ii+k);
      end
   else
      for ii=1:s
         out(ii) = in(ii-k,ii);
      end
   end
end
