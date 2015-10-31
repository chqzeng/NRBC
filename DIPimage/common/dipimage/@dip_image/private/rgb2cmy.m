%RGB2CMY   Convert color image from RGB to CMY

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.

function out = rgb2cmy(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

out = (255-in(1:3))*(1/255);
out = di_setcolspace(out,in(1).color,'CMY');
