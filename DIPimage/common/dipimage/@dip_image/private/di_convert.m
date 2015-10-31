%OUT = DI_CONVERT(IN,CLASS)
%    Convert any numeric array to any other type.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.

function out = di_convert(in,class)
if nargin ~= 2 | ~isnumeric(in), error('Wrong input.'), end
%#function int8, uint8, int16, uint16, int32, uint32, int64, uint64, single, double
out = feval(class,in);
