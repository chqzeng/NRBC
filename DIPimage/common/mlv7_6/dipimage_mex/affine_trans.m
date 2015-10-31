%AFFINE_TRANS   Rotate, translate and scale a 2D image
%
% The transformation is done as follows:
%  R = [zx*cos(ang)  zx*sin(ang) tx;
%       -zy*sin(ang) zy*cos(ang) ty;
%       0            0           1]
% The rotation is performed around the center of the image.
%
% SYNOPSIS:
%  [image_out,R] = affine_trans(image_in, zoom, translation, angle)
% 
% PARAMETERS:
%  zoom        = array containing a zoom
%  translation = array containing a transloation
%  angle       = rotation angle [in rad]
%  
%  Interpolation is linear.
%
% SEE ALSO: rotation, rotate, resample, rotation3d, find_affine_trans, fmmatch

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2009

function [out,R] = affine_trans(varargin)

d = struct('menu','Manipulation',...
           'display','2D affine transformation',...
           'inparams',struct('name',       {'in', 'zoom','sh','alp'},...
                             'description',{'Input image','Zoom','Translation','Rotation'},...
                             'type',       {'image','array','array','array'},...
                             'dim_check',  {0,1,1,0},...           
                             'range_check',{[],'R+','R','R'},...
                             'required',   {1, 0,0,0},...                            
                             'default',    {'a', 1,[0 0],0}...
                              ),...
           'outparams',struct('name',{'out','R'},...
                              'description',{'Output image','Rotation matrix'},...
                              'type',{'image','array'}...
                              )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end

try
   [in, zoom, sh, alp ] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)~=2
   error('Input image not 2D.');
end

N = 3;
sx = 1/zoom(1);
sy = 1/zoom(2);
center = size(in)./2;
R = zeros(N,N);
T = eye(N,N);
R(N,N) = 1;

%Translate
T(1:2,N) = -center;

%Rotate
R(1,1) = cos(alp)*sx;
R(1,2) = sin(alp)*sx;
R(2,1) = -1*sin(alp)*sy;
R(2,2) = cos(alp)*sy;

%combine step
B = R*T;
%Translate back
T(1:2,N) = center + sh;

%combine step to overall Matrix and go
R = T*B;
out = dip_image(affine_trans_low(double(in),R));

