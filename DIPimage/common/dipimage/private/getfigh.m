%H = GETFIGH(ARG)
%    Parses an input argument and returns a valid figure handle.
%    The argument can be the name of a variable or a figure handle.
%    The figure window must exist. If the argument is invalid, produces
%    an error.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2001.

function h = getfigh(arg)
if ischar(arg)
   if strcmpi(arg,'other')
      error('String ''other'' no allowed as window handle');
   else
      h = dipfig('-get',arg);
      if h == 0
         error('Variable name not linked to figure window');
      end
   end
else
   h = arg;
end
if ~isfigh(h)
   error('Figure handle expected');
end
