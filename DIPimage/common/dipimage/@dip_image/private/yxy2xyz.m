%YXY2XYZ   Convert color image from Yxy to XYZ.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2000.
% 10 March 2008: Slight rewrite, hopefully increased performace (CL).

function out = yxy2xyz(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

out = dip_image('array',[3,1]);
tmp = dip_image('zeros',size(in(1)),'sfloat');
I = find(in(3).data);
tmp2 = dip_image(in(1).data(I))./dip_image(in(3).data(I));
tmp.data(I) = tmp2.data;
clear I tmp2
out(1) = in(2)*tmp;
out(2) = dip_image(in(1),'sfloat');
out(3) = tmp-out(1)-out(2);
out = di_setcolspace(out,in(1).color,'XYZ');
