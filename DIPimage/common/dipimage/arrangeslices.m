%ARRANGESLICES   Converts an n-D image into a 2D image by arringing the slices
%
% SYNOPSIS:
%  image_out = arrangeslices(image_in,ncolumns)
%
%  ncolumns:  number of columns in which the slices are arranged.
%
% DEFAULTS:
%  ncolumns = ceil(sqrt(N)), with N = prod(sz(3:end)), sz = size(image_in)
%
% NOTES:
%  If you want to show only part of the slices, use (for example):
%     arrangeslices(image(:,:,0:10:end))
%
%  For a 4D image you might want to set ncolums=size(image_in,3).
%
% SEE ALSO:
%   tile, detile

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2002
% 16 September 2004, fixed bug for ndims(in)>3.

function out = arrangeslices(in,ncolumns)
% check input arguments
if nargin < 1
   error('Image expected as input.')
elseif nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
else % if nargin > 1
   if length(ncolumns)~=1 | ~isnumeric(ncolumns) | ncolumns < 1 | mod(ncolumns,1)
      error('NCOLUMNS must be a positive integer scalar')
   end
end
if isa(in,'dip_image_array')
   % iterate for each image in the array...
   sz = size(in);
   out = newimar(sz);
   colsp = colorspace(in);
   if nargin<2
      for ii=1:prod(sz);
         out{ii} = arrangeslices(in{ii});
      end
   else
      for ii=1:prod(sz);
         out{ii} = arrangeslices(in{ii},ncolumns);
      end
   end
   out = colorspace(out,colsp);
else
   % some checks
   if ~isa(in,'dip_image')
      in = dip_image(in);
   end
   dip_type = datatype(in);
   in = dip_array(in);
   sz = size(in);
   if length(sz)<3
      out = dip_image(in);
      return
   elseif length(sz)>3
      sz(3) = prod(sz(3:end));
      sz(4:end) = [];
      in = reshape(in,sz);
   end
   % compute table size
   if nargin<2
      ncolumns = ceil(sqrt(sz(3)));
   end
   nrows = ceil(sz(3)/ncolumns);
   % add zeros to image for empty table elements
   if nrows*ncolumns > sz(3)
      in = cat(3,in,zeros(sz(1),sz(2),nrows*ncolumns-sz(3)));
   end
   % two reshapes and one permute do the trick (note that only the permute causes copying of the data)
   out = reshape(in,[sz(1),sz(2)*ncolumns,nrows]);
   out = permute(out,[1,3,2]);
   out = reshape(out,[sz(1)*nrows,sz(2)*ncolumns]);
   out = dip_image(out,dip_type);
end
