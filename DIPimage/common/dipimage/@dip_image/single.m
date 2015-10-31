%SINGLE   Convert dip_image object to single matrix.
%   A = SINGLE(B) converts the dip_image B to a single precision
%   n-dimensional matrix.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function out = single(in)
out = dip_array(in,'single');
