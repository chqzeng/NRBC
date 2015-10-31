%CMY2CMYK   Convert color image from CMY to CMYK.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 17 March 2004: Fixed bug probably introduced when binary images no
%                longer contained logical arrays (CL).

function out = cmy2cmyk(in,val)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end
if nargin < 2
   val = 1;
end

out = dip_image('array',[4,1]);
K = min(in);
C = in(1);
M = in(2);
Y = in(3);

if val == 1
   I = K>=0.99999;
   K.data(I) = 0.99999;
   out(1) = (C-K)/(1-K);
   out(2) = (M-K)/(1-K);
   out(3) = (Y-K)/(1-K);
   out(4) = K;
else
   out(1) = C-K;
   out(2) = M-K;
   out(3) = Y-K;
   out(4) = K;
end
out = di_setcolspace(out,in(1).color,'CMYK');
