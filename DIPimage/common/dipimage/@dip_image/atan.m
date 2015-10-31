%ATAN   Inverse tangent.
%  ATAN(B) is the arctangent of the pixels of B.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, December 2001.
% 24 June 2011: New version of COMPUTE1. (CL)

function img = atan(img)
try
   img = compute1('atan',img);
catch
   error(di_firsterr)
end
