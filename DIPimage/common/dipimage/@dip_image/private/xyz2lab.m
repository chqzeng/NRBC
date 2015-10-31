%XYZ2LAB   Convert color image from XYZ to L*a*b*.

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

function out = xyz2lab(in,xyz_set)

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

X = in(1)/Xn;
Y = in(2)/Yn;
Z = in(3)/Zn;

threshold = 0.008856;  % Assuming few elements are below threshold

I = Y<=threshold;
I = find(I.data);
fY = Y.^(1/3);
tmp = 7.787*dip_image(Y.data(I))+(16/116);
fY.data(I) = tmp.data;
L = 116*(fY)-16;

I = X<=threshold;
I = find(I.data);
a = X.^(1/3);
tmp = 7.787*dip_image(X.data(I))+(16/116);
a.data(I) = tmp.data;
a = (a-fY)*500;

I = Z<=threshold;
I = find(I.data);
b = Z.^(1/3);
tmp = 7.787*dip_image(Z.data(I))+(16/116);
b.data(I) = tmp.data;
b = (fY-b)*200;

out = di_joinchannels(in(1).color,'L*a*b*',L,a,b);
out = subsasgn(out,substruct('.','whitepoint'),XYZ_white);
