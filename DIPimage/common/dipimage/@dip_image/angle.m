%ANGLE  Phase angle for complex images and vector images.
%   ANGLE(B) returns the phase angles, in radians, of an image with
%   complex pixel values (see also ABS, REAL, IMAG).
%
%   ANLGE(B) returns the angles, in radians, of the pixels of a
%   vector image (see also ISVECTOR, NORM).

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2002.
% 24 June 2011: New version of COMPUTE2. (CL)

function out = angle(in)
if isscalar(in)
   try
      %#function atan2
      out = compute2('atan2',imag(in),real(in));
   catch
      error(di_firsterr)
   end
else
   if prod(imarsize(in))==2 & istensor(in)
      try
         %#function atan2
         out = compute2('atan2',in(2),in(1));
      catch
         error(di_firsterr)
      end
   else
      error('ANGLE is only implemented for 2D vectors.')
   end
end
