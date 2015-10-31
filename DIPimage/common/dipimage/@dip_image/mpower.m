%MPOWER   Overloaded operator for a^b.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2000.
% April 2004:    Added support for complex images (BR)
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 24 June 2011:  New version of COMPUTE2. (CL)

function out = mpower(in1,in2)
if isa(in1,'dip_image_array') | isa(in2,'dip_image_array')
   error('Matrix power not implemented for vector/tensor images.')
end
out_type='forcedouble';
try
   out = compute2('power',in1,in2,out_type);
catch
   error(di_firsterr)
end
