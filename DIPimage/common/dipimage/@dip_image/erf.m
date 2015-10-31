%ERF   Error function.
%  ERF(B) is the error function for each of the pixels of B.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% 24 June 2011: New version of COMPUTE1. (CL)

function img = erf(img)
try
   img = compute1('erf',img);
catch
   error(di_firsterr)
end
