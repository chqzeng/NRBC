%LAB2GREY   Convert color image from L*?*?* to grey-value image.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.
% June 2002: image.color.xyz added -> is overruled by 2nd argument (Judith)
% 10 March 2008: Slight rewrite, hopefully increased performace (CL).

function out = lab2grey(in,xyz_set)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

if nargin>1
   XYZ_white = xyz_set;
elseif isfield(in(1).color,'xyz')
   XYZ_white = in(1).color.xyz;
else
   XYZ_white = di_defaultwhite;
end

Yn = XYZ_white(2);
L = in(1);
if isa(L.data,'double')
   out = dip_image('zeros',imsize(L),'double');
else
   out = dip_image('zeros',imsize(L),'single');
end

m = L>8;
I = find(m.data);
tmp = (((dip_image(L.data(I))+16)/116).^3)*Yn;
out.data(I) = tmp.data;
m = ~m;
I = find(m.data);
tmp = dip_image(L.data(I)).*(Yn/903.3);
out.data(I) = tmp.data;
out = out*255;
out.color = '';
