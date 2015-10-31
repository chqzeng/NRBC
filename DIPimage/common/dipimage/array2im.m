%ARRAY2IM   Convert a dip_image_array to an image stack
%
% SYNOPSIS:
%  out = array2im(in)
%
% EXAMPLE:
%  a = readim
%  g = gradient(a)
%  b = array2im(g)  % here same as b = cat(3,g)
%  h = im2array(b)
%
% SEE ALSO:
%  im2array, cat, slice_ex, slice_in.

% (C) Copyright 1999-2004               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Jan 2004.

function out=array2im(in)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~isvector(in)
   error('Input is not a vector image.');
end
dim = ndims(in{1})+1;
out = cat(dim,in);
