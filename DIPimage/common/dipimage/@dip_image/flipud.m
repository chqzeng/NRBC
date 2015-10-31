%FLIPUD   Flips an image up/down.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.

function b = flipud(b)
if ~isscalar(b), error('Input is an array of images.'); end
if b.dims < 2
   error('Cannot flip up/down with less than two dimensions.')
end
b.data = flipdim(b.data,1);
