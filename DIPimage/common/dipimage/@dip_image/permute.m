%PERMUTE   Permute image dimensions.
%   B = PERMUTE(A,ORDER) rearranges the dimensions of A so that they
%   are in the order specified by the vector ORDER. The array
%   produced has the same values of A but the order of the subscripts
%   needed to access any particular element are rearranged as
%   specified by ORDER. The elements of ORDER must be a rearrangement
%   of the numbers from 1 to N.
%
%   See also DIP_IMAGE/SQUEEZE, DIP_IMAGE/EXPANDDIM,
%   DIP_IMAGE/SHIFTDIM, DIP_IMAGE/RESHAPE, DIP_IMAGE/CIRCSHIFT

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 6 March 2008: Bug fix in pixel dimension addition. (CL)
% 22 November 2013: Allowing physDims to be empty. (CL)

function in = permute(in,k)
if ~isscalar(in), error('Input is an array of images.'); end
if nargin~=2
   error('Not enough input arguments.');
elseif ~isnumeric(k) | sum(size(k)>1)>1 | prod(size(k))<1 | fix(k)~=k
   error('ORDER must be an integer vector.')
elseif length(k)~=in.dims
   error('ORDER must have NDIMS elements.')
elseif any(k<1) | any(k>in.dims)
   error('ORDER contains an invalid permutation index.')
elseif length(k)~=length(unique(k))
   error('ORDER cannot contain repeated permutation indices.')
end
k = k(:)'; % Make sure K is a 1xN vector.
if ~isempty(in.physDims.PixelSize)
   in.physDims.PixelSize = in.physDims.PixelSize(k);
end
if ~isempty(in.physDims.PixelSize)
   in.physDims.PixelUnits = in.physDims.PixelUnits(k); 
end
if in.dims > 1
   % Where we say 1, we mean 2.
   I = k==1;
   J = k==2;
   k(I) = 2;
   k(J) = 1;
   % The X index must be the second one for MATLAB.
   k = k([2,1,3:end]);
end
in.data = permute(in.data,k);
