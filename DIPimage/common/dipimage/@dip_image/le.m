%LE   Overloaded operator for a<=b.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2000.
% 15 September 2001: We don't need to use COMPUTE2 for relational operators.
% 15 November 2002:  Fixed binary images to work in MATLAB 6.5 (R13)
% February 2008:     Adding pixel dimensions and units to dip_image. (BR)
% 24 June 2011:      New version of COMPUTE2. (CL)
% 24 September 2011: Doing computation in DIPlib now, for singleton expansion. (CL)

function out = le(in1,in2)
try
   %#function dip_compare
   out = iterate('dip_compare',in1,in2,'<=');
catch
   error(di_firsterr)
end
