%ISSCALAR   True if IN is a scalar image.
%    ISSCALAR(IN) returns true if there is only one image in the
%    dip_image_array.
%
%    This is equivalent to ISA(IN,'dip_image').
%
%    See also: ISTENSOR, ISMATRIX, ISVECTOR, ISCOLUMN, ISROW.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, December 2005.

function result = isscalar(in)
if nargin ~= 1, error('Need an input argument.'); end
result = all(imarsize(in)==1);
