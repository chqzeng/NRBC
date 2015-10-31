%CAT   Concatenate (append, join) images.
%   CAT(DIM,A,B) concatenates the images A and B along
%   the dimension DIM.
%   CAT(1,A,B) is the same as [A,B].
%   CAT(2,A,B) is the same as [A;B].
%
%   CAT(DIM,A1,A2,A3,A4,...) concatenates the input images
%   A1, A2, etc. along the dimension DIM.
%
%   If any of the inputs is a dip_image_array, its images are
%   concatenated horizontally. CAT always produces a single
%   dip_image.
%
%   CAT(DIM,A) concatenates the images in the dip_image_array
%   A along the dimension DIM.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% 26 July 2007:     Reorganized to remove repeated code.
% February 2008:    Adding pixel dimensions and units to dip_image. (BR)
% 5 March 2008:     Bug fix.
% 24 July 2008:     Using default pixel size & units from DI_DEFAULTPHYSDIMS.
% 5 November 2008:  Fixed to work with images of different dimensionality.
% 15 July 2010:     Fixed to preserve ending singleton dimensions.

function out = cat(dim,varargin)
if nargin < 2, error('Erroneus input.'); end
if di_isdipimobj(dim), error('Erroneus input.'); end
% Collect all images in cell array
n = nargin-1;
if n > 1
   in = cell(1,n);
   in_dims = zeros(1,n);
   in_type = cell(1,n);
   in_phys = cell(1,n);
   for ii=1:n
      img = varargin{ii};
      if ~di_isdipimobj(img)
         img = dip_image(img);
      end
      if ~isscalar(img)
         img = cat(1,img);  % concatenate dip_image_array into single image
      end
      in{ii} = img.data;
      in_dims(ii) = img.dims;
      in_type{ii} = img.dip_type;
      in_phys{ii} = img.physDims;
   end
else
   img = varargin{1};
   n = prod(imarsize(img));
   in = cell(1,n);
   in_dims = zeros(1,n);
   in_type = cell(1,n);
   in_phys = cell(1,n);
   for ii=1:n
      in{ii} = img(ii).data;
      in_dims(ii) = img(ii).dims;
      in_type{ii} = img(ii).dip_type;
      in_phys{ii} = img(ii).physDims;
   end
end
% Find the correct output datatype
out_dims = max(dim,max(in_dims));
dpd = di_defaultphysdims(1);
for ii=1:length(in)
   if length(in_phys{ii}.PixelSize) < out_dims
      in_phys{ii}.PixelSize(end+1:out_dims) = dpd.PixelSize;
      in_phys{ii}.PixelUnits(end+1:out_dims) = dpd.PixelUnits;
   end
end
out_type = in_type{1};
out_phys = in_phys{1};
for ii=2:length(in)
   out_type = di_findtypex(out_type,in_type{ii});
   out_phys = di_findphysdims(out_phys,in_phys{ii});
end
% Convert images to the output type
for ii=1:length(in)
   if ~strcmp(in_type{ii},out_type)
      in{ii} = di_convert(in{ii},di_mattype(out_type));
   end
end
% Call CAT
if dim == 1
   dim = 2;
elseif dim == 2
   dim = 1;
end
try
   out = cat(dim,in{:});
catch
   error(di_firsterr)
end
out = dip_image('trust_me',out,out_type,out_dims,out_phys);
