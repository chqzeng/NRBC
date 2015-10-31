%SIGN   Signum function.
%   For each pixel in X, SIGN(X) returns 1 if the pixel
%   is greater than zero, 0 if it equals zero and -1 if it is
%   less than zero. For complex X, SIGN(X) = X / ABS(X).

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% 7 April 2009: Output is always sint8.
% 24 June 2011: New version of COMPUTE1, complex output for complex input. (CL)

function img = sign(img)
for ii=1:prod(imarsize(img))
   try
      if di_iscomplex(img(ii))
         img(ii) = compute1('sign',img(ii),'scomplex');
      else
         img(ii) = compute1('sign',img(ii),'sint8');
      end
   catch
      error(di_firsterr)
   end
end
