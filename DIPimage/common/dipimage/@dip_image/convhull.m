%CONVHULL  generates convex hull of a binary image.
%  CONVHULL(B) generates the (solid) convex hull of the binary image B.
%  CONVHULL(B,'no') or CONVHULL(B,0) generate only the outer shell (i.e.
%  the volume is not filled in).
%
%  CONVHULL uses the qhull algorithm. Under MATLAB 5, only 2D images are
%  supported. Under MATLAB 6, also 3D images can be processed.
%
%  NOTE: The 3D convex hull is not necessarily closed. The code that
%  draws the surface in the image is not very good at it.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Judith Dijk  May 2001
% September 2001:    Added filling-in of volume. Changed line-drawing. (CL)
% July 2002:         MATLAB 5 doesn't have the CONVHULLN function. (CL)
% November 2002:     Fix 2D, MATLAB 5 bug (Gerrit Polder)
% December 2006:     Bug fix, hull was shifted by 1 as here we have to use out.data (BR)
% 19 September 2007: Using new function MATLABVERSION. (CL)
% 21 September 2009: Changed something that looked like a bug, though I've
%                    never seen wrong behaviour. (CL)
% 17 December 2009:  Using new function MATLABVER_GE.

function [out,indx] = convhull(in,filli)

if ~isscalar(in), error('Input image must be scalar.'); end
if matlabver_ge([6,0])
   if in.dims<2 | in.dims>3
      error('Only implemented for 2D and 3D.');
   end
else
   if in.dims~=2
      error('Only implemented for 2D.');
   end
end

if nargin < 2
   filli = 1;
elseif ischar(filli)
   filli = strcmpi(filli,'yes');
elseif ~isnumeric(filli)
   error('Second argument should be ''yes'' or ''no'' (or 0 or 1)')
end

cc = findcoord(in-dip_binaryerosion(in,1,1,0)); % Only use edge pixels...
if length(cc) < 4
   error('Only 3 points in image, do it yourself...');
end
if matlabver_ge([6,0])
   ccc = convhulln(cc);             % use qhull algo from matlab
else
   ccc = convhull(cc(:,1),cc(:,2)); % use qhull algo from matlab
end

out = dip_image('zeros',size(in),'bin');
if in.dims == 2
   sz = size(out.data);
   strides = [sz(1);1];
   indx = [];
   for ii = 1:size(ccc,1)
      indx = [indx;bresenham2(cc(ccc(ii,1),:),cc(ccc(ii,2),:))*strides];
   end
   indx = unique(indx);
   out.data(indx+1) = 1;
   if filli
      out = dip_binaryclosing(out,1,2,0); %try to fil some holes
      out = ~dip_binarypropagation(out&0,~out,1,0,1); %propagation from border, low connect.
      % Better: bdilation, bpropagation, berosion. (CL)
   end
else % in.dims == 3
   sz = size(out.data);
   strides = [sz(1);1;sz(1)*sz(2)];
   indx = [];
   for ii = 1:size(ccc,1)
      indx = [indx;triangle3(cc(ccc(ii,1),:),cc(ccc(ii,2),:),cc(ccc(ii,3),:))*strides];
   end
   indx = unique(indx);
   out.data(indx+1) = 1;
   if filli
      out = dip_binaryclosing(out,2,3,0); %try to fil some holes
      out = ~dip_binarypropagation(out&0,~out,1,0,1); %propagation from border, low connect.
      % Better: bdilation, bpropagation, berosion. (CL)
   end
end

%
% computes coordinates of points that fill a triangle
%
function points = triangle3(pt1,pt2,pt3)
% Sort points according to distances.
points = [pt1;pt2;pt3];
length = sum([pt2-pt3;pt3-pt1;pt1-pt2].^2,2);
[length,I] = min(length);
pt3 = points(I,:);           % Point farthest away
points(I,:) = [];
pt1 = points(1,:);
pt2 = points(2,:);
% We walk along the shortest side of the triangle, and draw lines
% to the third point.
line = bresenham3(pt1,pt2);
points = [];
for ii=1:size(line,1)
   points = [points;bresenham3(line(ii,:),pt3)];
end

%
% computes coordinates of points along line from pt1 to pt2
%
function line = bresenham2(pt1,pt2)
point = pt2-pt1;
N = max(abs(point)); % the number of pixels needed.
if N==0
   line = pt1;
   return;
end
ii = (0:N)';    % this is better than (0:N)/N, because of round-off errors.
x = ii*(point(1)/N)+pt1(1);
y = ii*(point(2)/N)+pt1(2);
line = round([x,y]);

function line = bresenham3(pt1,pt2)
point = pt2-pt1;
N = max(abs(point)); % the number of pixels needed.
if N==0
   line = pt1;
   return;
end
ii = (0:N)';    % this is better than (0:N)/N, because of round-off errors.
x = ii*(point(1)/N)+pt1(1);
y = ii*(point(2)/N)+pt1(2);
z = ii*(point(3)/N)+pt1(3);
line = round([x,y,z]);
