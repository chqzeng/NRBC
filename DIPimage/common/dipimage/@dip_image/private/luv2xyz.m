%LUV2XYZ   Convert color image from L*u*v* to XYZ.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.
% June 2002: image.color.xyz added -> is overruled by 2nd argument (Judith)

function out = luv2xyz(in,xyz_set)

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

L = double(in(1));
u = double(in(2));
v = double(in(3));

X = zeros(size(L));
Y = X;
Z = X;

io = L>8;
I = find(io);
Y(I) = (((L(I)+16)/116).^3)*Yn;
io = ~io;
I = find(io);
Y(I) = L(I).*(Yn/903.3);

tmpn = Xn + 15*Yn + 3*Zn;
un = 4*Xn ./ tmpn;
vn = 9*Yn ./ tmpn;

tmp = 13*L;
I = find(tmp);
u(I) = u(I) ./ tmp(I) + un;
v(I) = v(I) ./ tmp(I) + vn;
I = find(~tmp);
u(I) = 0;
v(I) = 0;

I = find(v);
tmp = zeros(size(L));
tmp(I) = 9*Y(I) ./ v(I);
X = u .* tmp * 0.25;

Z = (tmp - X - 15*Y)*(1/3);

out = di_joinchannels(in(1).color,'XYZ',X,Y,Z);
out = subsasgn(out,substruct('.','whitepoint'),XYZ_white);
