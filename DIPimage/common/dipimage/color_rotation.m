%COLOR_ROTATION   Rotation from Blue-Black to White Black
%
% SYNOPSIS
%  image_out = rotBktoWK(image_in, color1, color2)
%
% DESCRIPTION:
%  The axis Blue-blacK is rotated to White-blacK around the Red-Green axis.
%  The distance to the gamut of the RGB space is relatively the same.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet W. Verbeek
% implemented in dipimage: Judith Dijk, July 2002.
% 26 July 2007: Removed use of DIP_IMAGE_ARRAY (CL).
% 20 October 2007: Moved to toolbox directory. (CL)

%rotates Blue-blacK to White-blacK
%around Red-Green through A=A*=(.5,.5,.5)
%leaves lA unchanged

function out = color_rotation(in, color1, color2)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if ~isa(in,'dip_image_array') | ~iscolor(in)
   error('Input needs to be a color image.');
end
if nargin < 2, color1 = [0 0 1]; end
if nargin < 3, color2 = [1 1 1]; end
if isa( color1, 'char')
   switch(color1)
      case 'blue', color1 = [0 0 1];
      case 'green', color1 = [0 1 0];
      case 'red', color1 = [1 0 0];
      case 'yellow', color1 = [1 1 0];
      case 'cyan', color1 = [0 1 1];
      case 'magenta', color1 = [1 0 1];
      otherwise, error('The first color is not recognized');
   end
end
if isa( color2, 'char')
   switch(color2)
      case 'blue', color2 = [0 0 1];
      case 'green', color2 = [0 1 0];
      case 'red', color2 = [1 0 0];
      case 'yellow', color2 = [1 1 0];
      case 'cyan', color2 = [0 1 1];
      case 'magenta', color2 = [1 0 1];
      otherwise, error('The second color is not recognized');
   end
end
if prod(size(color1))~=3 | prod(size(color2))~=3
   error( 'The color vector should have 3 values');
end
if all(color1(:)==color2(:))
   error('The color vectors are the same, which does not give a rotation');
end
ori_col = colorspace(in);
in = colorspace(in, 'RGB');

tmp = RGBto_rgblA(in,.5,.5,.5);
two = 2^-.5;
three = 3^-.5;
six= 6^-.5;
rotation = [two,six,three,0;-two,six,three,0;0,-2*six,three,0;0,0,0,1];
rotation = determine_rot_matrix(color1, color2);
rotation(:, 4) = 0;
rotation(4, :) = 0;
rotation(4, 4) = 1;
tmp = rotation*tmp;
out = rgblAtoRGB(tmp,.5,.5,.5);

%to eliminate negative roundoff errors:
%#function clip
iterate('clip',out,0,255);

%out{1} = (out{1}>=0).*out{1};
%out{2} = (out{2}>=0).*out{2};
%out{3} = (out{3}>=0).*out{3};

%out{1} = (out{1}<=255).*out{1};
%out{2} = (out{2}<=255).*out{2};
%out{3} = (out{3}<=255).*out{3};

%out = joinchannels( 'RGB', out(1), out(2), out(3));
%for i=1:3
%   out(i).color = in(i).color;
%end
out = colorspace(out, ori_col);

% RGBto_rgblA
% This function converts a standard RGB image to relative RGB values which are
% scaled between 0-aR and 1-aR for R, and so on. If aR, aG and aB are 0.5, this
% is a cube with center 0, 0, 0 ranging between -0.5 and 0.5.
%
% the last value lA is the smallest distance to one of the cube planes. This is
% used to scale values with respect to this plane

function out=RGBto_rgblA(in,aR,aG,aB)
r=in{1}/255;
g=in{2}/255;
b=in{3}/255;
r=r-aR;
g=g-aG;
b=b-aB;

eucl=(r*r+g*g+b*b)^0.5;
eucl2 = (eucl ~= 0).* eucl + (eucl ==0 ).*0.00001;
r=r/eucl2;
g=g/eucl2;
b=b/eucl2;

r2 = (r ~= 0).* r + (r ==0 ).*0.00001;
g2 = (g ~= 0).* g + (g ==0 ).*0.00001;
b2 = (b ~= 0).* b + (b ==0 ).*0.00001;
facelength=min(min((nonneg(r)-aR)/r2,(nonneg(g)-aG)/g2),(nonneg(b)-aB)/b2);
facelength2 = (facelength ~= 0).* facelength + (facelength ==0 ).*0.00001;
lA =eucl/facelength2;
lA = ( facelength ~= 0).* lA;
out=dip_image({r;g;b;lA});

% rgblAtoRGB
% This function converts rgblA back to RGB. See RGBtorgblA for the explanation
% of this conversion.

function out=rgblAtoRGB(in,aR,aG,aB)
out=dip_image('array',3);
r=in{1};
g=in{2};
b=in{3};
lA=in{4};

r = r*(abs(r) > 0.0001) + (abs(r) <=0.0001).* 0.0001;
g = g*(abs(g) > 0.0001) + (abs(g) <=0.0001).* 0.0001;
b = b*(abs(b) > 0.0001) + (abs(b) <=0.0001).* 0.0001;

facelength=min(min((nonneg(r)-aR)/r,(nonneg(g)-aG)/g),(nonneg(b)-aB)/b);

eucl=lA*facelength;
eucl(isinf(facelength))=0;
out{1}=255*(eucl*r+aR);
out{2}=255*(eucl*g+aG);
out{3}=255*(eucl*b+aB);
out=colorspace(out,'RGB');


%nonneg
function out=nonneg(in)
%example:  <0  =0  >0
%   sign   -1   0   1
% nonneg    0   1   1
%out = sign(1+sign(in)); % Piet's version
out = +(in>=0);          % Cris's version

function out = determine_rot_matrix(vector1, vector2, m);

if( nargin < 1)
   vector1 = [0 0 1]; % blauw
end
if( nargin < 2)
   vector2 = [1 1 1]; % wit
end
if( nargin < 3)
   m = cross( vector1, vector2 )';
end
cos_phi = sum( vector1.* vector2)./(norm(vector1).*norm(vector2));
phi = acos( cos_phi);

ez = m./norm(m);
ey = m(1:2)./norm(m(1:2));
ey(1) = -1.*ey(1);
ey(3) = 0;
ex = cross( ey, ez);

P = [ex ey ez];
Rz = [cos(phi) -sin(phi) 0
      sin(phi) cos(phi)  0
      0 0 1];
out = P*Rz*P';


% m = cross( vector1, vector2 )';
% cos_alpha = sum( vector1.* vector2)./(norm(vector1).*norm(vector2));
% alpha = acos( cos_alpha);
% a = m(1);
% b = m(2);
% c = m(3);
% x = sqrt( a.^2 + b.^2);
% y = sqrt( a.^2 + b.^2 + c.^2);
% R1 = [a./x -b./x 0; b./x a./x 0; 0 0 1];
% R2 = [c./y 0 x./y; 0 1 0; -x./y 0 c./y];
% R3 = [cos(alpha) -sin(alpha) 0; sin(alpha), cos(alpha), 0; 0 0 1];
% R4 = [c./y 0 -x./y; 0 1 0; x./y 0 c./y];
% R5 = [a./x b./x 0; -b./x a./x 0; 0 0 1];

% out = R1*R2*R3*R4*R5;
