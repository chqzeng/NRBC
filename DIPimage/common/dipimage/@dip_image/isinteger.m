%ISINTEGER   True for integer-typed image.
%   ISINTEGER(B) returns true if B is uint8, uint16, uint32, sint8, sint16 or sint32.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2006.
% 7 March 2013: Fixed bug when input is binary.

function out = isinteger(in)
if ~isscalar(in)
   error('Parameter "in" is an array of images.')
else
   if length(in.dip_type)>=4 & strcmp(in.dip_type(2:4),'int')
      out = true;
   else
      out = false;
   end
end
