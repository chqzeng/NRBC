%FLIPLR   Flips an image left/right.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.

function b = fliplr(b)
if ~isscalar(b), error('Input is an array of images.'); end
if b.dims < 1
   error('Cannot flip left/right with less than one dimension.')
end
b.data = flipdim(b.data,2);
