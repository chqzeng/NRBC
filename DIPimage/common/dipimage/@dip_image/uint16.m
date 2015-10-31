%UINT16   Convert dip_image object to uint16 matrix.
%   A = UINT16(B) converts the dip_image B to a 16-bit, unsigned integer,
%   n-dimensional matrix.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function out = uint16(in)
out = dip_array(in,'uint16');
