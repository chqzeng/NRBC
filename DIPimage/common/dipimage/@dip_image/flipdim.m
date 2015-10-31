%FLIPDIM   Flips an image along specified dimension.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.

function b = flipdim(b,dim)
if ~isscalar(b), error('Input is an array of images.'); end
if nargin~=2
   error('Requires two arguments.')
end
if ~isnumeric(dim) | length(dim)~=1 | fix(dim)~=dim | dim<1
   error('DIM must be a positive integer.')
end
if b.dims < dim
   error('Cannot flip along non-existent dimension.')
end
if dim == 2
   dim = 1;
elseif dim == 1 & b.dims > 1
   dim = 2;
end
b.data = flipdim(b.data,dim);
