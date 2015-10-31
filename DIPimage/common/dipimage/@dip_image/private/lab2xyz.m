%LAB2XYZ   Convert color image from L*a*b* to XYZ.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, July 2000.
% 28 June 2001: Somewhat rewritten by Cris.
% June 2002: image.color.xyz added -> is overruled by 2nd argument (Judith)
% 10 March 2008: Again slight rewrite, hopefully increased performace (CL).

function out = lab2xyz(in,xyz_set)

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

Xn = XYZ_white(1);
Yn = XYZ_white(2);
Zn = XYZ_white(3);

L = in(1);
a = in(2);
b = in(3);

threshold = 7.787*0.008856+(16/116); % Assuming few elements are below threshold

fY = (L+16)*(1/116);
I = fY<=threshold;
I = find(I.data);
Y = fY.^3;
tmp = (1/7.787)*(dip_image(fY.data(I))-(16/116));
Y.data(I) = tmp.data;
Y = Y*Yn;

a = a/500 + fY;
I = a<=threshold;
I = find(I.data);
X = a.^3;
tmp = (1/7.787)*(dip_image(a.data(I))-(16/116));
X.data(I) = tmp.data;
X = X*Xn;

b = fY - b/200;
I = b<=threshold;
I = find(I.data);
Z = b.^3;
tmp = (1/7.787)*(dip_image(b.data(I))-(16/116));
Z.data(I) = tmp.data;
Z = Z*Zn;

out = di_joinchannels(in(1).color,'XYZ',X,Y,Z);
out = subsasgn(out,substruct('.','whitepoint'),XYZ_white);
