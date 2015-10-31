%OUT = DI_CREATE(SZ,CLASS,COMPLEX)
%    Create a ZEROS array of any numeric type.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 24 June 2011: Added optional COMPLEX argument.

function out = di_create(sz,class,comp)
%#function int8, uint8, int16, uint16, int32, uint32, int64, uint64, single, double
out(prod(sz)) = feval(class,0);
out = reshape(out,sz);
if nargin>2 & comp
   out = complex(out);
end
