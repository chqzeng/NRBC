%CONJ   Complex conjugate.
%   CONJ(B) returns the complex conjugate of each pixel in B.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% June 2006:    Added tensor image support (BR)
% 24 June 2011: New version of COMPUTE1. (CL)

function img = conj(img)
for ii=1:prod(imarsize(img))
   if di_iscomplex(img(ii))
      try
         img(ii) = compute1('conj',img(ii));
      catch
         error(di_firsterr)
      end
   end
end
