%EXPANDDIM   Appends dimensions of size 1
%   B = EXPANDDIM(A,N) increases the dimensionality of the image A
%   to N, if its dimensionality is smaller. The dimensions added will
%   have a size of 1.
%
%   See also SQUEEZE, SHIFTDIM, PERMUTE, RESHAPE

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Rainer Heintzmann, Ondrej Mandula, April 2006.
% 9 June 2006 - This can be done so much simpler (CL)
% July 2006, changed functionality to set the dimension to N as intended by RH (BR)
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 5 March 2008: Simplified increasing pixel dimension arrays. (CL)
% 24 July 2008: I guess my previous fix was wrong??? Also strengthened input checking. (CL)

function in = expanddim(in,dims)

if ~isnumeric(dims) | length(dims)~=1 | mod(dims,1)
   error('Number of dimensions must be scalar integer.');
end

n = dims - in.dims;
if n<0
   error('Image has larger dimensionality than requested number of dimensions')
elseif n>0
   in.dims = dims;
   pd = di_defaultphysdims(1);
   in.physDims.PixelSize(end+1:dims) = pd.PixelSize;
   in.physDims.PixelUnits(end+1:dims) = pd.PixelUnits;
end
