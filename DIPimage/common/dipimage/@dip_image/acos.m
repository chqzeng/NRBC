%ACOS   Inverse cosine.
%  ACOS(B) is the arccosine of the pixels of B.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Nov 2000.
% October 2005:  Added different outtype if arccos returns complex values (BR)
% July 2006:     Bug fix (BR,FF)
% 10 March 2008: Fixed bug. COMPUTE1 has a new PHYSDIMS input parameter.
% 24 June 2011:  New version of COMPUTE1. (CL)

function img = acos(img)
try
   img = compute1('acos',img);
catch
   error(di_firsterr)
end
