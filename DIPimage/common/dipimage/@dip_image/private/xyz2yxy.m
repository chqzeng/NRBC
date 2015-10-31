%XYZ2YXY   Convert color image from XYZ to Yxy.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2000.
% 10 March 2008: Slight rewrite, hopefully increased performace (CL).

function out = xyz2yxy(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

out = dip_image('array',[3,1]);
out(1) = dip_image(in(2),'sfloat');
out(2) = dip_image('zeros',imsize(in),'sfloat');
out(3) = out(2);
sumall = in(1)+in(2)+in(3);
I = find(sumall.data);
tmp = dip_image(in(1).data(I))./dip_image(sumall.data(I));
out(2).data(I) = tmp.data;
tmp = dip_image(in(2).data(I))./dip_image(sumall.data(I));
out(3).data(I) = tmp.data;
out = di_setcolspace(out,in(1).color,'Yxy');
