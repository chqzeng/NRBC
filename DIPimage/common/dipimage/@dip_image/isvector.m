%ISVECTOR   True if IN is a vector image.
%    ISVECTOR(IN) checks the size of the tensor image IN,
%    returning true if the tensor has at least two components
%    and has only one tensor dimension larger than 1.
%
%    See also: ISTENSOR, ISMATRIX, ISCOLUMN, ISROW, ISSCALAR.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Cris Luengo, June 2001.
% 15 November 2002: Returning logical value in all cases.
% 1 May 2006:       Calling ISTENSOR.

function result = isvector(in)
if nargin ~= 1, error('Need an input argument.'); end
result = logical(0);
sz = imarsize(in);
N = prod(sz);
if N~=max(sz) | N<2
   return
end
result = istensor(in);
