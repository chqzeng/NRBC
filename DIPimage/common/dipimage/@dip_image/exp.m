%EXP   Exponential.
%  EXP(B) is the exponential of the pixels of B, e to the B.
%  For complex Z=A+i*B, EXP(Z) = EXP(A)*(COS(B)+i*SIN(B)).

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% September 2000: Added complex output.
% February 2008:  Adding pixel dimensions and units to dip_image. (BR)
% 11 March 2008:  Forcing double output again.
% 24 June 2011:   New version of COMPUTE1. (CL)

function img = exp(img)
try
   img = compute1('exp',img,'forcedouble');
catch
   error(di_firsterr)
end
