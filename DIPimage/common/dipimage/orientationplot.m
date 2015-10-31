%ORIENTATIONPLOT   Plot 2/3D orientation
%
% SYNOPSIS:
%   orientationplot(in1, in2, mask, subsample, scale, arrow)
%
% PARAMETERS:
%  in1: dip_image_array containing the vector 2/3D
%      or the angle phi 2/3D
%  in2: angle theta 3D
%  mask: mask image
%  subsample: array containing the subsampling factors
%  scale: scale of the lines ploted
%  arrow: 'none','arrow'
%
% DEFAULTS:
%  subsampling: 8
%  scale: 0.5
%  arrow: 'none'

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Aug 2001.
% March 2002:        Corrected fliped axis, matlab <-> dipimage. (BR)
% March 2002:        Small bug fix. (CL+BR)
% 10 September 2008: Actually returning the handles as output. (CL)

function out = orientationplot(varargin)

d = struct('menu','Display',...
   'display','Orientation plot',...
   'inparams',struct('name',       {'in1','in2','mask','subsample','scale','arrow'},...
    'description',{'Orientaion input 1','Orientaion input 2','Mask Image','Subsampling','Scaling','Arrow'},...
    'type',       {'image','image','image','array', 'array','option'},...
    'dim_check',  {0,0,0,1,0,0},...
    'range_check',{[],[],[],'R+','R+',{'none','arrow'}},...
    'required',   {1,0,0,0,0,0},...
    'default',    {'a','[]','[]',8,0.5,'none'}...
   ),...
   'outparams',struct('name',{'out'},...
                      'description',{'Line handles'},...
                      'type',{'handle'}...
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
   [in1,in2,mask,value,scale,arr] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if isvector(in1)
   vdim = length(in1); %vector dimension
   if vdim ~= ndims(in1{1})
      error('Vector and image dimension do not match.');
   end
   if vdim < 2 | vdim > 3
      error('Input only 2D or 3D image.');
   end
   vx = in1{1};
   vy = in1{2};
   if vdim == 3
      vz = in1{3};
   else
      vz = [];
   end
elseif isa(in1,'dip_image')
   vx = cos(in1);
   vy = sin(in1);
   if ndims(in1) == 3
      sin_in2 = sin(in2);
      vx = vx * sin_in2;
      vy = vy * sin_in2;
      clear sin_in2
      vz = cos(in2);
   else
      vz = [];
   end
else
   error('Scalar or vector image expected.')
end

if ~isempty(mask)
   vx = mask * vx;
   vy = mask * vy;
   if ~isempty(vz)
      vz = mask * vz;
   end
end

vx = dip_subsampling(vx, value);
vy = dip_subsampling(vy, value);
if ~isempty(vz)
   vz = dip_subsampling(vz, value);
end

figure;
if isempty(vz)
   [x,y] = meshgrid(0:size(vx,1)-1,0:size(vy,2)-1);
   if strcmp(arr,'none')
      out = quiver(x,y,double(vx),double(vy),scale,'.');
   else
      out = quiver(x,y,double(vx),double(vy),scale);
   end
else
   [x,y,z] = meshgrid(0:size(vx,1)-1,0:size(vy,2)-1,0:size(vz,3)-1);
   if strcmp(arr,'none')
      out = quiver3(x,y,z,double(vx),double(vy),double(vz),scale,'.');
   else
      out = quiver3(x,y,z,double(vx),double(vy),double(vz),scale);
   end
end

axis equal
axis ij % correct for flipped axes
