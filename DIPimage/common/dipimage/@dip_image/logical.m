%LOGICAL   Convert dip_image object to logical matrix.
%   A = LOGICAL(B) converts the dip_image B to a logical
%   n-dimensional matrix.
%
%   This function is invoked by commands such as
%     if b(ii,jj), ... ; end

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2004.

function out = logical(in)
if ~isscalar(in)
   error('Parameter "in" is an array of images.')
else
   out = logical(in.data);
end
