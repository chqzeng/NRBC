%XYZ2LUV   Convert color image from XYZ to L*u*v*.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.
% June 2002: image.color.xyz added -> is overruled by 2nd argument (Judith)

function out = xyz2luv(in,xyz_set)

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

X = double(in(1));
Y = double(in(2));
Z = double(in(3));
Y0 = Y./Yn;

L = zeros(size(X));
u = L;
v = L;

io = Y0 > 0.008856;
I = find(io);
L(I)= 116.*((Y0(I)).^(1/3))-16;
io = ~io;
I = find(io);
L(I)= 903.3.*Y0(I);

tmp = X + 15*Y + 3*Z;
I = find(tmp);
u(I) = 4*X(I) ./ tmp(I);
v(I) = 9*Y(I) ./ tmp(I);

tmpn = Xn + 15*Yn + 3*Zn;
un = 4*Xn ./ tmpn;
vn = 9*Yn ./ tmpn;

tmp = 13*L;
u = tmp.*(u-un);
v = tmp.*(v-vn);

out = di_joinchannels(in(1).color,'L*u*v*',L,u,v);
out = subsasgn(out,substruct('.','whitepoint'),XYZ_white);
