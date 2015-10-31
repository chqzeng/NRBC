%ISTENSOR   True if IN is a tensor image.
%    ISTENSOR(IN) checks images in dip_image_array IN, and returns
%    true (non-zero) if they are all of the same size.
%
%    A tensor image has pixels represented by a tensor. A scalar image
%    (with one component) is also a tensor image.
%
%    See also: ISMATRIX, ISVECTOR, ISCOLUMN, ISROW, ISSCALAR.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 15 November 2002: returning logical value in all cases.

function result = istensor(in)
if nargin ~= 1, error('Need an input argument.'); end
N = prod(imarsize(in));
s = imsize(in(1));
result = logical(1);
for ii=2:N
   if ~isequal(s,imsize(in(ii)))
      result = logical(0);
      return
   end
end
