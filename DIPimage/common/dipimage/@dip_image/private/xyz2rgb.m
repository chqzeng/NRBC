%XYZ2RGB   Convert color image from RGB to XYZ.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2000.
% 20 August 2009: Put XYZDATA matrix into separate file.

function out = xyz2rgb(in,A);

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

if nargin < 2
   A = xyzdata;
end
A = inv(A).*255;
out = A*in(:);
out = di_setcolspace(out,in(1).color,'RGB');
