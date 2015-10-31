%MRDIVIDE   Overloaded operator for a/b.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 21 September 2009: Allowing tensor/scalar operation
% 24 June 2011:      New version of COMPUTE2. (CL)
% 26 September 2011: Computations done by DIPlib. (CL)

function out = mrdivide(in1,in2)
if isa(in2,'dip_image_array')
   error('Matrix division not implemented for vector/tensor images.')
end
out_type='';
if dipgetpref('KeepDataType')
   out_type = di_forcedatatype(in1,in2);
end
try
   out = compute2('dip_div',in1,in2,out_type);
catch
   error(di_firsterr)
end
