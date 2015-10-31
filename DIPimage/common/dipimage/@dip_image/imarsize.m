%IMARSIZE   Size of the image array.
%   IMARSIZE(B) returns an N-D array containing the lengths of
%   each dimension in the array of images in B.
%
%   IMARSIZE(B,DIM) returns the length of the dimension specified
%   by the scalar DIM.
%
%   [M,N] = IMARSIZE(B) returns the number of rows and columns in
%   separate output variables. [M1,M2,M3,...,MN] = IMARSIZE(B)
%   returns the length of the first N dimensions of B.
%
%   If B is a scalar image, IMARSIZE returns [1,1].

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2007, modified from SIZE.

function [varargout] = imarsize(in,dim)
if nargin > 1
   if ~di_isdipimobj(in) % means dim must be of type dip_image!
      error('Dimension number must be a non-negative integer.')
      % This is a copy of the error message of the original SIZE.
   end
end
s = builtin('size',in);
if nargout > 1
   if nargin ~= 1, error('Unknown command option.'); end
   for ii=1:min(length(s),nargout)
      varargout{ii} = s(ii);
   end
   for ii=ii+1:nargout
      varargout{ii} = 1;
   end
else
   if nargin == 1
      varargout{1} = s;
   else %nargin == 2
      try
         varargout{1} = s(dim);
      catch
         error(di_firsterr)
      end
   end
end
