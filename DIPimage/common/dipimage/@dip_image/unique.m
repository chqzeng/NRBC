%UNIQUE   Get the unique grey levels in an image.
%   [VALUES,POSITIONS] = UNIQUE(B) gets the unique values in B and the
%   position of the last occurrences of each value B.
%
%   [VALUES,POSITIONS] = UNIQUE(B,M) firsts masks B with the mask
%   image M. M may be [] for no mask.
%
%   UNIQUE(...,'first') returns the position of the first occurrence
%   of each value, instead of the last. UNIQUE(...,'last') is the
%   default.

% (C) Copyright 2011, Cris Luengo. All rights reserved.
%
% Cris Luengo, January 2011.

function [value,position] = unique(in,mask,order)

try
   in = dip_array(dip_image(in));
catch
   error(di_firsterr)
end
if nargin == 2
   if ischar(mask)
      order = mask;
      mask = [];
   else
      order = 'last';
   end
elseif nargin < 2
   mask = [];
   order = 'last';
end

if ~isempty(mask)
   try
      mask = dip_image(mask);
   catch
      error(di_firsterr)
   end
   if ~islogical(mask)
      error('MASK should be a binary image.')
   end
   mask = logical(dip_array(mask));
   if ~isequal(size(in),size(mask))
      error('MASK should have the same size as the input image.')
   end
   if nargout > 1
      [value,position] = unique(in(mask),order);
      I = find(mask);
      position = I(position) - 1;
   else
      value = unique(in(mask));
   end
else
   if nargout > 1
      [value,position] = unique(in,order);
      position = position - 1;
   else
      value = unique(in);
   end
end
value = dip_image(value);
