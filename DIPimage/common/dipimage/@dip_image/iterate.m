%ITERATE   Apply a function to all images in array.
%   B = ITERATE(FUN,A,X,Y,Z,...) where A is a dip_image_array,
%   returns a dip_image_array with the result of applying the
%   function FUN, with parameters X, Y, Z, etc. to each image
%   in A.
%
%   B = ITERATE(FUN,X,Y,Z,...), with one or more of the
%   parameters a dip_image_array, all with the same size,
%   returns an array with this same size, each image being the
%   result of the function FUN with parameters X, Y, Z, etc.,
%   where each dip_image_array is substituted by one of its
%   images. For example,
%     c = iterate('max',a,b);
%   where A and B are N-by-M dip_image_arrays, does
%     c = newimar(size(a));
%     for ii=1:N*M, c{ii} = max(a{ii},b{ii}); end
%
%   Note that a color image is a dip_image_array object. Color
%   space information is kept, except if there is more than one
%   color image as input, and they are represented in different
%   color spaces. There is no support yet for applying a filter
%   in selected channels only.
%
%  NOTE:
%    When using the MATLAB Compiler, make sure to add a %#function
%    pragma to register the function being called by ITERATE:
%       %#function max
%       c = iterate('max',a,b);
%
%   See also: IMARFUN, SLICE_OP

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 25 October 2001: Added color image support.
% 25 July 2008:    Allowing function handle input and scalar images.

% TODO: allow for n-D images as input, instead of image arrays. The
% looping should be done over the last image dimension, much like
% SLICE_OP. That function then becomes obsolete.

function a = iterate(fun,varargin)
if ~any(strcmp(class(fun),{'char','function_handle'}))
   error('First parameter should be a string or function handle')
end
n = nargin-1;
isarray = zeros(n,1);
sz = [];
anyarray = 0;
colsp = '';
for ii=1:n
   if isa(varargin{ii},'dip_image_array')
      isarray(ii) = 1;
      if ~anyarray
         anyarray = 1;
         sz = imarsize(varargin{ii});
         colsp = colorspace(varargin{ii});
      else
         szz = imarsize(varargin{ii});
         if ~isequal(szz,sz)
            error('All dip_image_arrays should have the same size.');
         end
         if isempty(colsp)
            colsp = colorspace(varargin{ii}); % Using the colorspace of the first color image
         elseif iscolor(varargin{ii}) & ~strcmp(colsp,colorspace(varargin{ii}))
            colsp = 'none'; % don't keep colorspace information
         end
      end
   end
end
if ~anyarray
   % This doesn't break anything I hope? - MvG - 25-07-2008
   % error('At least one parameter should be a dip_image_array.');
   a = feval(fun,varargin{:});
else
   a = dip_image('array',sz);
   args = varargin;
   for jj=1:prod(sz)
      for ii=1:n
         if isarray(ii)
            args{ii} = varargin{ii}(jj);
         end
      end
      a(jj) = feval(fun,args{:});
   end
   if ~strcmp(colsp,'none')
      a = colorspace(a,colsp);
   end
end
