%SIZE   Size of the image or image array.
%   SIZE(B) returns an N-D array containing the lengths of
%   each dimension in the image in B.
%
%   SIZE(B,DIM) returns the length of the dimension specified
%   by the scalar DIM.
%
%   [M,N] = SIZE(B) returns the number of rows and columns in
%   separate output variables. [M1,M2,M3,...,MN] = SIZE(B)
%   returns the length of the first N dimensions of B.
%
%   If B is an array of images, SIZE returns the dimensions of
%   the array itself, not of the images.
%
%   See also: IMSIZE, IMARSIZE.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May-June 1999.
% 5 January 2001: SIZE(A) now returns NDIMS(A) elements.
% 20 April 2001: No, it didn't. Now it does.
% 5 April 2007: Separated code out into IMSIZE and IMARSIZE.

function varargout = size(varargin)
if ~di_isdipimobj(varargin{1}) % means dim must be of type dip_image!
   error('Dimension number must be a non-negative integer.')
   % This is a copy of the error message of the original SIZE.
end
varargout = cell(1,max(nargout,1));
try
   if isscalar(varargin{1})
      [varargout{:}] = imsize(varargin{:});
   else
      [varargout{:}] = imarsize(varargin{:});
   end
catch
   error(di_firsterr)
end
