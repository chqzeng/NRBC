%END   Overloaded function for indexing expressions.
%   END(A,K,N) is called for indexing expressions involving the object
%   A when END is part of the K-th index out of N indices.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 1999.
% 25 May 2000: Corrected function so it does not give an error when
%              indexing using a single index.

%??? TODO: what if A{end}(end) ???

function ii = end(a,k,n)

if isscalar(a)
   if n == 1
      if k ~= 1
         error('This cannot happen.')
      end
      ii = prod(size(a.data))-1;
   else
      if n ~= a.dims
         error('Number of indices does not match dimensionality.')
      end
      if k > n
         error('This cannot happen.')
      end
      if a.dims > 1
         if k == 1
            k = 2;
         elseif k == 2
            k = 1;
         end
      end
      ii = size(a.data,k)-1;
   end
else
   ii = builtin('end',a,k,n);
end
