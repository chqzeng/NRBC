%B = ISFIGH(H)
%    Returns true if H is the handle of a figure window.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.

function b = isfigh(h)
b = 0;
if length(h)==1 & ishandle(h)
   if strcmp(get(h,'type'),'figure')
      b = 1;
   end
end
