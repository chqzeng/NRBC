%ISINF   True for infinite pixels.
%   ISINF(B) returns a binary image with 1's where the pixels
%   in B are +Inf or -Inf.
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

function img = isinf(img)
try
   img = compute1('isinf',img,'bin');
catch
   error(di_firsterr)
end
