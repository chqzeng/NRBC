%GREY2XYZ   Convert grey-value image to XYZ color image.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2008.
% 20 August 2009: Put XYZDATA matrix into separate file.

function out = grey2xyz(in,A)

if prod(imarsize(in)) ~= 1
   warning('Expected grey-value input. No conversion done.')
   out = in;
end

if nargin < 2
   A = xyzdata;
end
A = A./255;
A = sum(A,2);
X = A(1)*in;
Y = A(2)*in;
Z = A(3)*in;
out = di_joinchannels(in(1).color,'XYZ',X,Y,Z);
