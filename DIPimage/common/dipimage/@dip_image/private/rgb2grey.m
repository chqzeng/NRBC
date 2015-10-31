%RGB2GREY   Convert color image from RGB to grey-value image.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.
% 20 August 2009: Put XYZDATA matrix into separate file.

function out = rgb2grey(in,A)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

if nargin < 2
   A = xyzdata;
end
A = A(2,:);
out = A*in(:);
out.color = '';
