%DATATYPE  Extracts the data type string from a dip_image.
%   A = DATATYPE(B) returns the data type of B as a string.
%   DIPlib convention of data type names.
%
%   [A1,A2,A3,...An] = DATATYPE(B) returns the n data types in the
%   dip_image_array B in the arrays A1 through An.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2001.

function varargout = datatype(in)
n = prod(imarsize(in));
if nargout ~= n & ~(n == 1 & nargout <= 1)
   error('The number of output arguments must match the number of images in the array.')
end
varargout = cell(1,n);
[varargout{:}] = deal(in.dip_type);
