%DOUBLE   Convert dip_measurement object to double matrix.
%   A = DOUBLE(B) converts the measurement data B to a double
%   precision matrix. To extract a specific measurement, use the
%   syntax A = B.MSRN.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 21 April 2001: This function now returns the catenated DATA elements

function out = double(in)
out = cat(1,in.data{:})';
