%ISFLOAT   True for float-typed image.
%   ISFLOAT(B) returns true if B is sfloat or dfloat.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2006.

function out = isfloat(in)
if ~isscalar(in)
   error('Parameter "in" is an array of images.')
else
   out = strcmp(in.dip_type(2:end),'float');
end
