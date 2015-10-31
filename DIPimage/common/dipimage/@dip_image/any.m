%ANY   True if any pixel of image is nonzero.
%   ANY(B) returns true if any pixel in the image B is different from 0.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2001.

function out = any(in)
if ~isscalar(in), error('Parameter 1 is an array of images.'); end
try
   out = any(in(1).data(:));
catch
   error(di_firsterr)
end
