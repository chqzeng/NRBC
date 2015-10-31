%ISREAL   True for non-complex image.
%   ISREAL(B) returns true if B is not complex.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 19 March 2001: Not doing isreal(in.data) anymore.

function out = isreal(in)
if ~isscalar(in)
   error('Parameter "in" is an array of images.')
else
   out = ~di_iscomplex(in);
end
