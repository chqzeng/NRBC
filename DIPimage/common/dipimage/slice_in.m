%SLICE_IN   Inserts one slice in an n-D image
%
% SYNOPSIS:
%  out = slice_in(in, slice, plane, dim)
%
% PARAMETERS:
%  slice:  slice (image) to be written into image in
%  plane:  slice number                     ( 0 ... size(in,dim)-1 )
%  dim:    dimension along which to slice   ( -ndims(in) ... ndims(in)-1 )
%          (negative dimension counts from the end)
%
% NOTE:
%  imsize(slice) should be equal to:
%     sz = imsize(in);
%     sz(dim+1) = [];
%  That is, it should have one fewer dimension than the
%  input image, and should be of the same size as the input
%  image in each of the dimensions other than 'dim'.
%
%  The command 'slice_ex', with the same value for the
%  parameter 'dim', gives an image of correct size for
%  'slice_in'. See the example below.
%
% DEFAULTS:
%  dim = -1 (last dimension)
%
% EXAMPLE:
%  a = readim('chromo3d');
%  b = gaussf(slice_ex(a,0));
%  a = slice_in(a,b,0);
%
%  SEE ALSO:
%   slice_ex, slice_op, im2array, array2im, iterate.

% (C) Copyright 2010, Cris Luengo
% Centre for Image Analysis, Uppsala, Sweden.

function in = slice_ex(varargin)

d = struct('menu','Manipulation',...
           'display','Insert slice',...
           'inparams',struct('name',       {'in',         'slice',      'plane',       'dim'},...
                             'description',{'Input image','Slice image','Slice number','Slicing dimension'},...
                             'type',       {'image',      'image',      'array',       'array'},...
                             'dim_check',  {0,            0,            0,             0},...
                             'range_check',{[],           [],           'N',           'Z'},...
                             'required',   {1,            1,            1,             0},...
                             'default',    {'a',          'b',          0,             -1}...
                            ),...
           'outparams',struct('name',       {'out'},...
                              'description',{'Output image'},...
                              'type',       {'image'}...
                             )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      in = d;
      return
   end
end
try
   [in,slice,plane,dim] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

N = ndims(in{1});
if dim<0
   dim = N+dim;
end
dim = dim+1;
if dim<1 | dim>N
   error('Dimension out of bounds.');
end
if plane>=imsize(in,dim)
   error('Plane out of bounds.');
end

s = imsize(in);
s(dim) = 1;
if prod(s)~=prod(imsize(slice)) | ~isequal(imarsize(in),imarsize(slice))
   error('Slice image not correct size')
end
%#function reshape
slice = iterate('reshape',slice,s);

s = repmat({':'},1,N);
s{dim} = plane;
in(s{:}) = slice;
