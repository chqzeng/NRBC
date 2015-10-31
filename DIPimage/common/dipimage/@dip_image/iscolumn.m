%ISCOLUMN   True if IN is a column vector image.
%    ISCOLUMN(IN) checks the size of the tensor image IN,
%    returning true if the tensor is of size [N 1], with
%    N a non-negative integer.
%
%    See also: ISTENSOR, ISMATRIX, ISVECTOR, ISROW, ISSCALAR.

% (C) Copyright 1999-2010, All rights reserved
% Cris Luengo, September 2010.
% (based on ISVECTOR).

function result = iscolumn(in)
if nargin ~= 1, error('Need an input argument.'); end
result = logical(0);
sz = imarsize(in);
if length(sz)~=2 | sz(1)<0 | sz(2)~=1
   return
end
result = istensor(in);
