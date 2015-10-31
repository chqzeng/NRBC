%COORD2IMAGE   Generate binary image with ones at coordinates.
%
% SYNOPSIS:
%  image_out = coord2image(coordinates,sz)
%
% PARAMETERS:
%  coordinates: coordinates array (xy/xyz/xyzt positions)
%  sz:          size of the image, defaults to 256 on each side.
%               If an image is given, its size is used.
%
% EXAMPLE:
%  co = round(reshape(rand(10),50,2).*255);
%  coord2image(co,[256 256])
%
% SEE ALSO:
%  DIP_IMAGE/FINDCOORD, DIP_IMAGE/SUB2IND.

% (C) Copyright 2004-2007      Department of Molecular Biology
%     All rights reserved      Max-Planck-Institute for Biophysical Chemistry
%                              Am Fassberg 11, 37077 G"ottingen
%                              Germany
%
% Bernd Rieger & Cris Luengo, Feb 2005.
% 18 March 2007:     Made 2nd input argument optional. Coordinates outside of
%                    image are ignored. Fixed to work on 1D images. (CL)
% 13 September 2007: SZ argument can also be an image.
% 28 September 2010: Using DIP_IMAGE/SUB2IND for ease. (CL)

function out = coord2image(t,sz)
% Avoid being in menu
if nargin == 1 & ischar(t) & strcmp(t,'DIP_GetParamList')
   out = struct('menu','none');
   return
end
if nargin<1
   error('Two input arguments required.');
end

if ~isnumeric(t)
   error('Coordinates array must be numeric.');
end
st = size(t);
if length(st) ~= 2
   error('Input coordinates in NxD 2D array.');
end
D = st(2);
noo = st(1);

t = round(t);

if nargin<2
   sz = repmat(256,1,D);
else
   if isa(sz,'dip_image') | isa(sz,'dip_image_array')
      sz = imsize(sz);
   elseif ~isnumeric(sz)
      error('Size argument must be numeric or an image.')
   end
   sz = sz(:)';
   if D ~= length(sz)
      error('Dimensionality of the coordinates does not match the image size.');
   end
end
szD = repmat(sz-1,noo,1);
I = any(t>szD,2) | any(t<0,2);
t(I,:) = [];

out = newim(sz,'bin');
out(sub2ind(out,t)) = 1;
