%SUBSINDEX   Subscript index.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, December 2001.

function a = subsindex(a)
if ~isscalar(a)
   error('Cannot index using an image array.')
end
if ~islogical(a)
   error('Only binary images can be used to index.')
end
a = find(a.data)-1;
