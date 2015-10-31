%LOG   Natural logarithm.
%  LOG(B) is the natural logarithm of the pixels of B.
%  Complex results are produced if B is not positive.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 24 June 2011:  New version of COMPUTE1. (CL)

function img = log(img)
try
   img = compute1('log',img);
catch
   error(di_firsterr)
end
