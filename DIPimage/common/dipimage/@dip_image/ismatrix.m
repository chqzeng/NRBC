%ISMATRIX   True if IN is a vector image.
%    ISMATRIX(IN) checks the size of the tensor image IN,
%    returning true if the tensor is of size [N M], with
%    N and M non-negative integers.
%
%    See also: ISTENSOR, ISVECTOR, ISCOLUMN, ISROW, ISSCALAR.

% (C) Copyright 1999-2010, All rights reserved
% Cris Luengo, September 2010.
% (based on ISVECTOR).

function result = ismatrix(in)
if nargin ~= 1, error('Need an input argument.'); end
result = logical(0);
sz = imarsize(in);
if length(sz)~=2 | any(sz<0)
   return
end
result = istensor(in);
