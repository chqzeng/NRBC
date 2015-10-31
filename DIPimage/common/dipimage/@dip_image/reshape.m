%RESHAPE   Change size of an image.
%   B = RESHAPE(A,M,N,...) returns an image with the same
%   pixels as A but reshaped to have the size M-by-N-by-...
%   M*N*... must be the same as PROD(SIZE(A)).
%
%   B = RESHAPE(A,[M N ...]) is the same thing.
%
%   In general, RESHAPE(A,SIZ) returns an image with the same
%   elements as A but reshaped to the size SIZ. PROD(SIZ) must be
%   the same as PROD(SIZE(A)).
%
%   Note that RESHAPE takes pixels row-wise from A.
%
%   See also DIP_IMAGE/SQUEEZE, DIP_IMAGE/EXPANDDIM,
%   DIP_IMAGE/SHIFTDIM, DIP_IMAGE/PERMUTE, DIP_IMAGE/CIRCSHIFT

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, January 2001.
% 29 August 2001:   Fixed bug: now it can produce 1-D images.
% February 2008:    Adding pixel dimensions and units to dip_image. (BR)
% 5 March 2008:     Bug fix in pixel dimension addition. (CL)
% 14 April 2008:    Bug fix for ndims(out)~=ndims(in). (MvG & CL)
% 22 November 2013: Allowing physDims to be empty. (CL)

function in = reshape(in,varargin)
if ~isscalar(in), error('Input is an array of images.'); end
if nargin > 2
   for ii=1:nargin-1
      if ~isnumeric(varargin{ii}) | prod(size(varargin{ii})) ~= 1 | mod(varargin{ii},1) | varargin{ii}<1
         error('Size arguments must be positive scalar integers.')
      end
   end
   n = cat(2,varargin{:});
else
   n = varargin{1};
   if ~isnumeric(n) | ((length(n) > 1) & (sum(size(n)~=1) ~= 1)) | any(mod(n,1)) | any(n<1)
      error('Size vector must be a row vector with positive integer elements.')
   end
end
try
   in.dims = length(n);
   %can only work if the physicalDimensions are the same in dimensions that are reshaped
   if ~isempty(in.physDims.PixelSize) & ~isempty(in.physDims.PixelUnits)
      in.physDims = di_consistentphysdims(in.physDims);
      if length(in.physDims.PixelSize)>in.dims
         in.physDims.PixelSize = in.physDims.PixelSize(1:in.dims);
         in.physDims.PixelUnits = in.physDims.PixelUnits(1:in.dims);
      elseif length(in.physDims.PixelSize)<in.dims
         in.physDims.PixelSize(1:in.dims) = in.physDims.PixelSize(1);   % All dims have same info anyway.
         in.physDims.PixelUnits(1:in.dims) = in.physDims.PixelUnits(1);
      end
   end
   n = [n,ones(1,2-length(n))];
   in.data = permute(in.data,[2,1,3:ndims(in.data)]);
   in.data = reshape(in.data,n);
   in.data = permute(in.data,[2,1,3:ndims(in.data)]);
catch
   error(di_firsterr)
end
