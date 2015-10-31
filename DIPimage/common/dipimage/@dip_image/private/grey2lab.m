%GREY2LAB   Convert grey-value image to L*a*b* color image.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2008.

function out = grey2lab(in,xyz_set)

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

Y = in/(255*XYZ_white(2));

threshold = 0.008856;  % Assuming few elements are below threshold

I = Y<=threshold;
I = find(I.data);
fY = Y.^(1/3);
tmp = 7.787*dip_image(Y.data(I))+(16/116);
fY.data(I) = tmp.data;
L = 116*(fY)-16;

a = dip_image('zeros',imsize(L),'sfloat');
b = a;

out = di_joinchannels(in(1).color,'L*a*b*',L,a,b);
out = subsasgn(out,substruct('.','whitepoint'),XYZ_white);
