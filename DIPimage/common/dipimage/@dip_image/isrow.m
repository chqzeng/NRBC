%ISROW   True if IN is a row vector image.
%    ISROW(IN) checks the size of the tensor image IN,
%    returning true if the tensor is of size [1 N], with
%    N a non-negative integer.
%
%    See also: ISTENSOR, ISMATRIX, ISVECTOR, ISCOLUMN, ISSCALAR.

% (C) Copyright 1999-2010, All rights reserved
% Cris Luengo, September 2010.
% (based on ISVECTOR).

function result = isrow(in)
if nargin ~= 1, error('Need an input argument.'); end
result = logical(0);
sz = imarsize(in);
if length(sz)~=2 | sz(1)~=1 | sz(2)<0
   return
end
result = istensor(in);
