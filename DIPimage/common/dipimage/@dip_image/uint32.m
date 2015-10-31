%UINT32   Convert dip_image object to uint32 matrix.
%   A = UINT32(B) converts the dip_image B to a 32-bit, unsigned integer,
%   n-dimensional matrix.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function out = uint32(in)
out = dip_array(in,'uint32');
