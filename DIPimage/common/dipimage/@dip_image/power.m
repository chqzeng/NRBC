%POWER   Overloaded operator for a.^b.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2000.
% 6 November 2000: Also overloaded for tensor images.
% Jan 2004:        Added possibility of in2 being a dip_image or array
% April 2004:      Added support for complex images (BR)
% February 2008:   Adding pixel dimensions and units to dip_image. (BR)
% 6 March 2008:    Fixed to work again with image arrays. (CL)
% 24 June 2011:    New version of COMPUTE2. Outputs always doubles. (CL)

function out = power(in1,in2)
try
   out = compute2('power',in1,in2,'forcedouble');
catch
   error(di_firsterr)
end
