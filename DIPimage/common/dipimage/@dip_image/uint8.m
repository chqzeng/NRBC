%UINT8   Convert dip_image object to uint8 matrix.
%   A = UINT8(B) converts the dip_image B to a 8-bit, unsigned integer,
%   n-dimensional matrix.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 1999.

function out = uint8(in)
out = dip_array(in,'uint8');