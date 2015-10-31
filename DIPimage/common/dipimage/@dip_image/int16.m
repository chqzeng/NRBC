%INT16   Convert dip_image object to int16 matrix.
%   A = INT16(B) converts the dip_image B to a 16-bit, signed integer,
%   n-dimensional matrix.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function out = int16(in)
out = dip_array(in,'int16');
