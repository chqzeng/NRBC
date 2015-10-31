%LAB2LCH   Convert color image from L*a*b* to L*C*h*.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2008.

function out = lab2lch(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

a = in(2); % a = C * cos(h);
b = in(3); % b = C * sin(h);
C = sqrt(a^2+b^2);
h = atan2(b,a);
out = di_joinchannels(in(1).color,'L*C*h*',in(1),C,h);
