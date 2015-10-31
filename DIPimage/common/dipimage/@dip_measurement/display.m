%DISPLAY   Overloaded function for DISPLAY.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function display(in)
if isequal(get(0,'FormatSpacing'),'compact')
   disp([inputname(1) ' ='])
   disp(in)
else
   disp(' ')
   disp([inputname(1) ' ='])
   disp(' ')
   disp(in)
   disp(' ')
end
