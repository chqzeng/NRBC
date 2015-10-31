%SCANNER_CALIBRATION   Derive a profile for a calibrated scanner
%
% SYNOPSIS:
%  out = scanner_calibration(RGB_in, XYZ_in, ord)
%
% DEFAULTS:
%  ord = 1
%
% DESCRIPTION:
%  In this function a polynomial is fitted between measured RGB values and
%  their reference XYZ values. This polynomial can be of the first, second or
%  third order. The polynomial can be used for transforming measured RGB values
%  to unknown XYZ values with scan_rgb2xyz.
%  Note that this function uses the optimization toolbox.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, August 2002.
% 20 October 2007: Moved to toolbox directory. (CL)
% 17 December 2009: Using new function MATLABVER_GE.

function out = scanner_calibration(RGB_in, XYZ_in, ord)
% Avoid being in menu
if nargin == 1 & ischar(RGB_in) & strcmp(RGB_in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

if nargin < 2
   error('Device and reference values are needed for this function');
end
if( nargin < 3)
   ord = 1;
end
if ord ~= 1 & ord ~=2 & ord ~=3
   error('The order should be 1, 2 or 3');
end

if ~isa(RGB_in,'dip_image_array') | ~iscolor(RGB_in) | ~strcmp(colorspace(RGB_in), 'RGB')
   error('The device image should be a color RGB image');
end
if ~isa(XYZ_in,'dip_image_array') | ~iscolor(XYZ_in) | ~strcmp( colorspace(XYZ_in), 'XYZ')
   error('The reference image should be a color XYZ image');
end
if ~matlabver_ge([6,0])
   error('This function works only for matlab version 6 and up');
end
if isempty( ver('optim'))
   error('This function needs the optimization toolbox');
end

global R;
global G;
global B;
global X;
global Y;
global Z;

R = double(RGB_in{1})./255;
G = double(RGB_in{2})./255;
B = double(RGB_in{3})./255;

X = double(XYZ_in{1});
Y = double(XYZ_in{2});
Z = double(XYZ_in{3});

R = R(:);
G = G(:);
B = B(:);
X = X(:);
Y = Y(:);
Z = Z(:);

if ord == 1
   a0 = [1, 1, 1];
   a_X = lsqnonlin( @fun_1ordX, a0);
   a_Y = lsqnonlin( @fun_1ordY, a0);
   a_Z = lsqnonlin( @fun_1ordZ, a0);
elseif ord == 2
   a0 = [1, 1, 1, 0, 0, 0, 0, 0, 0];
   a_X = lsqnonlin( @fun_2ordX, a0);
   a_Y = lsqnonlin( @fun_2ordY, a0);
   a_Z = lsqnonlin( @fun_2ordZ, a0);
else
   a0 = [1, 1, 1, 1, 1, 1, 1, 1, 1, ...
         0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
   a_X = lsqnonlin( @fun_3ordX, a0);
   a_Y = lsqnonlin( @fun_3ordY, a0);
   a_Z = lsqnonlin( @fun_3ordZ, a0);
end

out = [a_X; a_Y; a_Z];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = fun_1ordX(x)

global R;
global G;
global B;
global X;

f= x(1).*R + x(2).*G + x(3).*B - X;

function f = fun_1ordY(x)

global R;
global G;
global B;
global Y;

f= x(1).*R + x(2).*G + x(3).*B - Y;


function f = fun_1ordZ(x)

global R;
global G;
global B;
global Z;

f= x(1).*R + x(2).*G + x(3).*B - Z;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function f = fun_2ordX(x)

global R;
global G;
global B;
global X;

f= x(1).*R + x(2).*G + x(3).*B  + ...
   x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
   x(7).*R.*G + x(8).*R.*B + x(9).*G.*B - X;

function f = fun_2ordY(x)

global R;
global G;
global B;
global Y;

f= x(1).*R + x(2).*G + x(3).*B  + ...
   x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
   x(7).*R.*G + x(8).*R.*B + x(9).*G.*B - Y;

function f = fun_2ordZ(x)

global R;
global G;
global B;
global Z;

f= x(1).*R + x(2).*G + x(3).*B  + ...
   x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
   x(7).*R.*G + x(8).*R.*B + x(9).*G.*B - Z;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f = fun_3ordX(x)

global R;
global G;
global B;
global X;

f= x(1).*R + x(2).*G + x(3).*B  + ...
   x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
   x(7).*R.*G + x(8).*R.*B + x(9).*G.*B + ...
   x(10).*R.^3 + x(11).*G.^3 + x(12).*B.^3 + ...
   x(13).*R.^2.*G + x(14).*R.^2.*B + x(15).*G.^2.*R +...
   x(16).*G.^2.*B + x(17).*B.^2.*R + x(18).*B.^2.*G + ...
   x(19).*R.*G.*B - X;

function f = fun_3ordY(x)

global R;
global G;
global B;
global Y;

f= x(1).*R + x(2).*G + x(3).*B  + ...
   x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
   x(7).*R.*G + x(8).*R.*B + x(9).*G.*B + ...
   x(10).*R.^3 + x(11).*G.^3 + x(12).*B.^3 + ...
   x(13).*R.^2.*G + x(14).*R.^2.*B + x(15).*G.^2.*R +...
   x(16).*G.^2.*B + x(17).*B.^2.*R + x(18).*B.^2.*G + ...
   x(19).*R.*G.*B - Y;

function f = fun_3ordZ(x)

global R;
global G;
global B;
global Z;

f= x(1).*R + x(2).*G + x(3).*B  + ...
   x(4).*R.^2 + x(5).*G.^2 + x(6).*B.^2 + ...
   x(7).*R.*G + x(8).*R.*B + x(9).*G.*B + ...
   x(10).*R.^3 + x(11).*G.^3 + x(12).*B.^3 + ...
   x(13).*R.^2.*G + x(14).*R.^2.*B + x(15).*G.^2.*R +...
   x(16).*G.^2.*B + x(17).*B.^2.*R + x(18).*B.^2.*G + ...
   x(19).*R.*G.*B - Z;
