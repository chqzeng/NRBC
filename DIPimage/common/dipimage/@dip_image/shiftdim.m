%SHIFTDIM   Shift dimensions (reorients/flips an image).
%   B = SHIFTDIM(X,N) shifts the dimensions of X by N. When N is
%   positive, SHIFTDIM shifts the dimensions to the left and wraps
%   the N leading dimensions to the end.  When N is negative,
%   SHIFTDIM shifts the dimensions to the right and pads with
%   singletons.
%
%   [B,NSHIFTS] = SHIFTDIM(X) returns the array B with the same
%   number of elements as X but with any leading singleton
%   dimensions removed. NSHIFTS returns the number of dimensions
%   that are removed.
%
%   See also DIP_IMAGE/SQUEEZE, DIP_IMAGE/EXPANDDIM,
%   DIP_IMAGE/PERMUTE, DIP_IMAGE/RESHAPE, DIP_IMAGE/CIRCSHIFT

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, January 2001.
% 6 Marach 2006:    Fixed to actually do as intended when n>0. (CL)
% February 2008:    Adding pixel dimensions and units to dip_image. (BR)
% 5 March 2008:     Bug fix in pixel dimension addition. (CL)
% 24 July 2008:     Using default pixel size & units from DI_DEFAULTPHYSDIMS. (CL)
% 22 November 2013: Allowing physDims to be empty. (CL)

function [in,nshifts] = shiftdim(in,n)
if ~isscalar(in), error('Input is an array of images.'); end
if nargin==1
   % Remove leading singleton dimensions
   sz = imsize(in);
   n = min(find(sz>1));                  % First non-singleton dimension.
   if ~isempty(n)
      if n>1
         olddim = in.dims;
         sz = sz(n:end);
         sz = [sz,ones(1,2-length(sz))];
         in.data = permute(in.data,[2,1,3:ndims(in.data)]);
         in.data = reshape(in.data,sz);
         in.data = permute(in.data,[2,1,3:ndims(in.data)]);
         in.dims = length(sz);
         if ~isempty(in.physDims.PixelSize)
            in.physDims.PixelSize = in.physDims.PixelSize(n:olddim);
         end
         if ~isempty(in.physDims.PixelUnits)
            in.physDims.PixelUnits = in.physDims.PixelUnits(n:olddim);
         end
      % else don't do anything
      end
   else
      % 0D image
      in.dims = 0;
      in.data = in.data(:);
      in.physDims.PixelSize = [];
      in.physDims.PixelUnits = {};
   end
   return
elseif ~isnumeric(n) | length(n)~=1
   error('N should be a scalar.')
end
if isequal(n,0) | isempty(in.data)
   nshifts = 0;                           % Quick exit if no shift required
else
   if n>0
      % Wrapped shift to the left
      n = mod(n,in.dims);
      order = 1:in.dims;
      if length(order)>1, order = order([2,1,3:end]); end
      order = order([n+1:in.dims,1:n]);
      if length(order)>1, order = order([2,1,3:end]); end
      in.data = permute(in.data,order);
      order = 1:in.dims;
      order = order([n+1:in.dims,1:n]);
      if ~isempty(in.physDims.PixelSize)
         in.physDims.PixelSize = in.physDims.PixelSize(order);
      end
      if ~isempty(in.physDims.PixelUnits)
         in.physDims.PixelUnits = in.physDims.PixelUnits(order);
      end
   else
      % Shift to the right (padding with singletons).
      sz = imsize(in);
      sz = [ones(1,-n),sz];
      sz = [sz,ones(1,2-length(sz))];
      in.data = permute(in.data,[2,1,3:ndims(in.data)]);
      in.data = reshape(in.data,sz);
      in.data = permute(in.data,[2,1,3:ndims(in.data)]);
      in.dims = length(sz);
      pd = di_defaultphysdims(1);
      if ~isempty(in.physDims.PixelSize)
         in.physDims.PixelSize = [repmat(pd.PixelSize,1,-n),in.physDims.PixelSize];
      end
      if ~isempty(in.physDims.PixelUnits)
         in.physDims.PixelUnits = [repmat(pd.PixelUnits,1,-n),in.physDims.PixelUnits];
      end
   end
   nshifts = n;
end
