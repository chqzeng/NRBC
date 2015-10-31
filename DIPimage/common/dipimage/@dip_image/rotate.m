%ROTATE   Rotate a vector image around an axis
%   ROTATE(V,AXIS,ANGLE) rotates the 3D vector image V about ANGLE
%   around the AXIS given by a second vector image or a vector.
%   The ANGLE should be given between [0,2pi]
%
%   LITERATURE: Computer Graphics, D.Hearn and M.P. Baker, Prentice
%               Hall, p.408-419
%
%   SEE ALSO: rotation, rotation3d

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Nov 2000
% 26 July 2007: Better testing for wrong input.

function out=rotate(v,axis,theta)
if nargin~=3
   error('Give 3 input arguments: vector image, axis, angle.');
end
if ~isnumeric(theta)
   error('Theta input needs to be numeric');
end
if ~isvector(v)
   error('Image is not a vector image.');
end
s = imarsize(v);
if s(1)~=3 & s(2)~=3
   error('First input not a 3D vector image.');
end
if theta<0 | theta>2*pi
   error('Angle out of range: 0,2pi');
end
if isnumeric(axis)
   s1 = size(axis);
else
   s1 = imarsize(axis);
end
if s1(1)~=3 & s1(2)~=3
   error('Axis needs to be 3D vector.');
end

M = dip_image('array',[3,3]);
axis = axis./norm(axis).*sin(theta/2);
a = axis(1);
b = axis(2);
c = axis(3);
s = cos(theta/2);
M(1,1) = 1-2*b*b-2*c*c;
M(1,2) = 2*a*b-2*s*c;
M(1,3) = 2*a*c+2*s*b;
M(2,1) = 2*a*b+2*s*c;
M(2,2) = 1-2*a*a-2*c*c;
M(2,3) = 2*b*c-2*s*a;
M(3,1) = 2*a*c-2*s*b;
M(3,2) = 2*b*c+2*s*a;
M(3,3) = 1-2*a*a-2*b*b;
out = M*v;
