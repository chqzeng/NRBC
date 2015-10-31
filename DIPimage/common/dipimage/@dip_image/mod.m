%MOD   Modulus (signed remainder after division).
%   MOD(x,y) is x - y*floor(x/y) if y ~= 0. By convention, MOD(x,0) is x.
%   The input x and y must be real arrays of the same size, or real scalars.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 24 June 2011: New version of COMPUTE2. (CL)

function out = mod(in1,in2)
try
   out = compute2('mod',in1,in2);
catch
   error(di_firsterr)
end
