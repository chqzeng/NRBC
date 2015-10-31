%IM2ARRAY   Convert an image stack to a dip_image_array
%
% SYNOPSIS:
%  out = im2array(in)
%
% EXAMPLE:
%  a = readim
%  g = gradient(a)
%  b = array2im(g)
%  h = im2array(b)
%
% SEE ALSO:
%  array2im, slice_ex, slice_in.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Jan 2004.
% 9 April 2007, Rewrote to use SUBSREF instead of EVAL. (CL)

function out=im2array(in)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image')
   if ~isnumeric(in)
      error('Input is not an image.')
   else
      in = dip_image(in);
   end
end
sz = imsize(in);
if length(sz) < 2
   error('Input image does not have enough dimensions.')
end
out = newimar(sz(end));
s = substruct('()',[repmat({':'},1,length(sz)-1),{0}]);
for ii=1:sz(end)
   s.subs{end} = ii-1;
   out{ii} = squeeze(subsref(in,s));
end
