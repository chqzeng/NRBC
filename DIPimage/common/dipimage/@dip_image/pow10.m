%POW10   Base 10 power.
%   POW10(B) is 10 raised to the power of B, on a per-pixel basis.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 10 March 2008: Fixed bug. COMPUTE2 has a new PHYSDIMS input parameter.
% 24 June 2011:  Simplified. (CL)

function img = pow10(img)
try
   img = power(img,10);
catch
   error(di_firsterr)
end
