%GREY2LUV   Convert grey-value image to L*u*v* color image.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2008.

function out = grey2luv(in,xyz_set)

if prod(imarsize(in)) ~= 1
   warning('Expected grey-value input. No conversion done.')
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

Y0 = double(in)./(255*Yn);

L = zeros(size(Y0));

io = Y0 > 0.008856;
I = find(io);
L(I)= 116.*((Y0(I)).^(1/3))-16;
io = ~io;
I = find(io);
L(I)= 903.3.*Y0(I);

u = dip_image('zeros',imsize(in),'sfloat');
v = u;

out = di_joinchannels(in(1).color,'L*u*v*',L,u,v);
out = subsasgn(out,substruct('.','whitepoint'),XYZ_white);
