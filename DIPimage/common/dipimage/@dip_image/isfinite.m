%ISFINITE   True for finite pixels.
%   ISFINITE(B) returns a binary image (mask) with 1's where the
%   pixels in B are finite.
%
%   For any B, ISFINITE(B), ISINF(B) and ISNAN(B) don't intersect
%   and their union is the whole image.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% 10 March 2008:    Fixed bug. COMPUTE1 has a new PHYSDIMS input parameter.
% 24 June 2011:     New version of COMPUTE1. (CL)

function img = isfinite(img)
try
   img = compute1('isfinite',img,'bin');
catch
   error(di_firsterr)
end
