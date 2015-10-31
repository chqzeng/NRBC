%CMYK2CMY   Convert color image from CMYK to CMY.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.

function out = cmyk2cmy(in,val)

if prod(imarsize(in)) ~= 4
   warning('Expected four components. No conversion done.')
   out = in;
end
if nargin < 2
   val = 1;
end

out = dip_image('array',[3,1]);
C = in(1);
M = in(2);
Y = in(3);
K = in(4);

if val == 1
   out(1) = min((C.*(1-K)+K),1);
   out(2) = min((M.*(1-K)+K),1);
   out(3) = min((Y.*(1-K)+K),1);
else
   out(1) = C+K;
   out(2) = M+K;
   out(3) = Y+K;
end
out = di_setcolspace(out,in(1).color,'CMY');
