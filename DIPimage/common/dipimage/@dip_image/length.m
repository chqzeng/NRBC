%LENGTH   Overloaded function.
%   LENGTH(B) is the same as MAX(SIZE(B)).

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2007.

function a = length(b)
a = size(b);
if isempty(a)
   a = 0;
else
   a = max(a);
end
