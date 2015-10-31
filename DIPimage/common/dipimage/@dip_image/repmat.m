%REPMAT   Replicate and tile an image.
%   B = REPMAT(A,M,N,...) replicates and tiles the image A to produce an
%   image of size SIZE(A).*[M,N]. Any number of dimensions are allowed.
%
%   B = REPMAT(A,[M N ...]) produces the same thing.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 20 April 2001: Fixed for dimensionalities of 0 and 1.
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 5 March 2008: Bug fix in pixel dimension addition. (CL)
% 12 August 2008: Bug fix when input is single pixel and requesting singleton dimensions. (CL)
% 22 November 2013: Allowing physDims to be empty. (CL)

function out = repmat(in,varargin)
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
dims = length(n);
switch dims
   case 0
      n = [1,1];
   case 1
      n = [n,1];
   otherwise
      n = n([2,1,3:end]);
end
try
   out = in;
   out.data = repmat(in.data,n);
   out.dims = dims;
   pd = di_defaultphysdims(1);
   out.physDims.PixelSize(end+1:dims) = pd.PixelSize;
   out.physDims.PixelUnits(end+1:dims) = pd.PixelUnits;
catch
   error(di_firsterr)
end
