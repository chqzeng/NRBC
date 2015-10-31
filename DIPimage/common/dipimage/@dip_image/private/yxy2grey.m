%YXY2GREY   Convert color image from Yxy to grey-value image.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.

function out = yxy2grey(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

out = in(1)*255;
out.color = '';
