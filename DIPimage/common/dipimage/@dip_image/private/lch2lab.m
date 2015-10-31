%LCH2LAB   Convert color image from L*C*h* to L*a*b*.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2008.

function out = lch2lab(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

C = in(2);
h = in(3);
a = C*cos(h);
b = C*sin(h);
out = di_joinchannels(in(1).color,'L*a*b*',in(1),a,b);
