%RGBNL2RGB   Convert color image from R'G'B' to RGB.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.

function out = rgbnl2rgb(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

out = dip_image('array',[3,1]);
out(1) = (out(1)*(1/255))^(2.5) * 255;
out(2) = (out(2)*(1/255))^(2.5) * 255;
out(3) = (out(3)*(1/255))^(2.5) * 255;
out = di_setcolspace(out,in(1).color,'R''G''B''');
