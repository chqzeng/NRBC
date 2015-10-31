%CLASS   Returns the class info for a dip_image.
%   CLASS(B) returns either 'dip_image' or 'dip_image_array'.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 1999.

function out = class(in)
if isscalar(in)
   out = 'dip_image';
else
   out = 'dip_image_array';
end
