%IMSIZE   Size of the image.
%   IMSIZE(B) returns an N-D array containing the lengths of
%   each dimension in the image in B.
%
%   IMSIZE(B,DIM) returns the length of the dimension specified
%   by the scalar DIM.
%
%   [M,N] = IMSIZE(B) returns the number of rows and columns in
%   separate output variables. [M1,M2,M3,...,MN] = IMSIZE(B)
%   returns the length of the first N dimensions of B.
%
%   If B is an array of images, IMSIZE only works if ISTENSOR is
%   true.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2007, modified from SIZE.

function [varargout] = imsize(in,dim)
if nargin > 1
   %#function isa
   if ~di_isdipimobj(in) % means dim must be of type dip_image!
      error('Dimension number must be a non-negative integer.')
      % This is a copy of the error message of the original SIZE.
   end
end
if ~isscalar(in)
   if istensor(in) % ISTENSOR calls IMSIZE, but only with a scalar image!
      in = in(1);
   else
      error('IMSIZE only works on scalar or tensor images.')
   end
end
if nargout > 1
   if nargin ~= 1, error('Unknown command option.'); end
   if ~isempty(in.data)
      s = size(in.data);
      if length(s)>1
         s = s([2,1,3:end]);
      end
      for ii=1:min(length(s),nargout)
         varargout{ii} = s(ii);
      end
      for ii=ii+1:nargout
         varargout{ii} = 1;
      end
   else
      for ii=1:nargout
         varargout{ii} = 0;
      end
   end
else
   if ~isempty(in.data)
      if nargin == 1
         s = size(in.data);
         if in.dims==0
            s = [];
         elseif in.dims==1
            s = prod(s);
         elseif length(s)<in.dims
            s = [s,ones(1,in.dims-length(s))];
         end
         if length(s)>1
            s = s([2,1,3:end]);
         end
         varargout{1} = s;
      else %nargin == 2
         if dim == 1
            dim = 2;
         elseif dim == 2
            dim = 1;
         end
         try
            varargout{1} = size(in.data,dim);
         catch
            error(di_firsterr)
         end
      end
   else
      varargout{1} = [];
   end
end
