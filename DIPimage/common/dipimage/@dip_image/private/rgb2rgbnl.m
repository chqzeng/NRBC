%RGB2RGBNL   Convert color image from RGB to R'G'B'.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.

function out = rgb2rgbnl(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

out = dip_image('array',[3,1]);
out(1) = (in(1)*(1/255))^(0.4) * 255;
out(2) = (in(2)*(1/255))^(0.4) * 255;
out(3) = (in(3)*(1/255))^(0.4) * 255;
out = di_setcolspace(out,in(1).color,'R''G''B''');
