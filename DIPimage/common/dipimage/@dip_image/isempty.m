%ISEMPTY   True for empty image.
%   ISEMPTY(B) returns true if B is an empty image.
%
%   If B is an image array, ISEMPTY can never be true.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 1999.
% 24 July 2000: returns FALSE if B is an image array.
% 15 November 2002: returning logical value in all cases.
% 12 August 2008: returns TRUE if B is an empty tensor array.

function out = isempty(in)
if istensor(in)
   out = isempty(in(1).data);
else
   out = logical(0);
end
