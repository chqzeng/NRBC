%POW2   Base 2 power.
%   POW2(B) is 2 raised to the power of B, on a per-pixel basis.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 10 March 2008: Fixed bug. COMPUTE1 has a new PHYSDIMS input parameter.
% 24 June 2011:  New version of COMPUTE1. (CL)

function img = pow2(img)
try
   img = compute1('pow2',img,'dfloat');
catch
   error(di_firsterr)
end
