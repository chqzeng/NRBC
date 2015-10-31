%ATAN2   Four quadrant inverse tangent.
%   ATAN2(Y,X) is the four quadrant arctangent of the real parts of the
%   pixels of X and Y.  -pi <= ATAN2(Y,X) <= pi.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 24 June 2011: New version of COMPUTE2. (CL)

function out = atan2(in1,in2)
try
   out = compute2('atan2',in1,in2);
catch
   error(di_firsterr)
end
