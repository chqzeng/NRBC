%NEWIMAR   Creates an array of empty dip_images
%   NEWIMAR(N) is an N-by-1 array of empty images.
%
%   NEWIMAR(N,M) or NEWIMAR([N,M]) is an N-by-M array of empty images.
%
%   NEWIMAR(N,M,P,...) or NEWIMAR([N,M,P,...]) is an N-by-M-by-P-by-...
%   array of empty images.
%
%   NEWIMAR(IMSIZE(A)) is the same size as A and all empty images.
%
%   NEWIMAR(A,B,C) is an array of images containing the images in A, B
%   and C, along the first dimension. This mode is used whenever there
%   is more than one input parameter, and any one of them is not scalar.
%   You can also use DIP_IMAGE({A,B,C}).
%
%  SEE ALSO: newim, newcolorim

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001. Copy of DIP_IMAGE_ARRAY

function out = newimar(varargin)
if nargin > 1
   imgs = 0;
   for ii=1:nargin
      if isa(varargin{ii},'dip_image') | prod(size(varargin{ii})) ~= 1
         imgs = 1;
         break;
      end
   end
   if imgs
      out = cell(nargin,1);
      for ii=1:nargin
         out{ii} = dip_image(varargin{ii});
      end
      %#function cat
      out = builtin('cat',1,out{:});
      return;
   else
      n = [varargin{:}];
   end
elseif nargin == 1
   n = varargin{1};
   if ischar(n) & strcmp(n,'DIP_GetParamList') % Avoid being in menu
      out = struct('menu','none');
      return
   end
   if ~isnumeric(n) | ((length(n) > 1) & (sum(size(n)~=1) ~= 1))
      error('Size vector must be a row vector with integer elements.')
   end
else
   error('Argument expected.')
end
try
   out = dip_image('array',n);
catch
   error(firsterr)
end
