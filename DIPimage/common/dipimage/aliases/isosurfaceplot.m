function isosurfaceplot(a,value);
%ISOSURFACEPLOT isosurface of a 3D image
%
%   ISOSURFACEPLOT(IMAGE, ISOVALUE) plots the isosurface of IMAGE
%
%   Standard the axis option is set to tight. If you want to see
%   the right scale use:  axis equal.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Jan 2001

if nargin ~=2
        error('Usage: isosurfaceplot(image, isovalue)');
end
if ~isa(a,'dip_image')
        error('Input image no dip_image.');
end
if ~isnumeric(value)
        error('Isovalue not numeric.');
end


if ndims(a)~=3
        error('Isosurfaceplot only for 3D images.')
end

figure;
isosurface(single(a),value);
axis tight;
xlabel('x'); ylabel('y'); zlabel('z');
view(3);
box on;
camlight
