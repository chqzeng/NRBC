%LENGTH   Returns the numer of objects in the measurement structure.
%   LENGTH(MSR) returns the number of label IDs, and is equivalent to SIZE(MSR,1)
%   or LENGTH(MSR.ID).

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2006.

function len = length(in)
len = length(in.id);
