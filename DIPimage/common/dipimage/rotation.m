%ROTATION   Rotate a 2D/3D image around an axis
%
% The rotation center is in the center of the image.
% Image rotation by means of shears
%
% SYNOPSIS:
%  image_out = rotation(image_in, angle, axis, method, bgval)
%
%  axis
%     2D: meaningless
%     3D: 1 = x-axis, 2 = y-axis, 3 = z-axis
%  method
%     Interpolation method. String containing one of the following values:
%     'default', 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh', 'nn',
%     'lanczos2', 'lanczos3', 'lanczos4', 'lanczos6', 'lanczos8'.
%     For binary images, use 'nn'.
%  bgval
%     Value used to fill up the background. String containing one of the
%     following values:
%     'zero', 'min', 'max'.
%
% DEFAULTS:
%  axis   = '3' z-axis
%  method = 'lanczos3'
%  bgval  = 'zero'
%
% NOTES:
%  Sign of the 2D rotation: implementation in the mathmetical sense, but
%  note the y-axis is positive downwards! Thus: left turning has negative
%  sign, and right positive.
%
%  For exact rotations of multiples of 90 degrees, use the rot90 method
%  instead. Note that rot90 reverses the sign of the angle as compared to
%  this function.
%
%  For interpolation methods that do not generate values outside the input
%  range ('linear', 'zoh' and 'nn'), the output data type is the same as
%  that of the input. For other interpolation methods, integer images are
%  cast to single-precision floating point before calling the underlying
%  library functions DIP_ROTATION or DIP_ROTATION3D_AXIS. If this behaviour
%  is undesired, please call the corresponding library function directly.
%
% BUG:
%  Some bgval and method combinations produce wrong output.
%
% SEE ALSO: dip_image/rot90, rotation3d, dip_image/rotate, resample.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2001
% 16 September 2011: Removed attempt at computing pixel sizes in rotated
%                    image -- just didn't make any sense.
%                    Added 'iterate' for 3D images as well. (CL)
% 7 March 2013:      Casting to float for most interpolation methods.
%                    Allowing binary input.
%                    'lanczos3' is now the default interpolation method. (CL)

function out = rotation(varargin)

d = struct('menu','Manipulation',...
           'display','Rotation around an axis',...
           'inparams',struct('name',       {'in',         'angle',      'axis',  'method',              'bgval'},...
                             'description',{'Input image','Angle (rad)','Axis',  'Interpolation Method','Background Value'},...
                             'type',       {'image',      'array',      'option','option',              'option'},...
                             'dim_check',  {0,            0,            0,       0,                     0},...
                             'range_check',{[],           [],           {1,2,3}, {'bspline','4-cubic','3-cubic','linear','zoh','nn','lanczos2','lanczos3','lanczos4','lanczos6','lanczos8'},...
                                                                                                       {'zero', 'min', 'max'}},...
                             'required',   {1,            1,            0,       0,                     0},...
                             'default',    {'a',          pi/4,         3,       'lanczos3',            'zero'}...
                            ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                             )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end
if nargin >= 4 & isequal(varargin{4},'bilinear')
   varargin{4} = 'linear';
end
try
   [in,angle, axis,method,bgval] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ~any(strcmp(method,{'linear','zoh','nn'}))
   for ii=1:prod(imarsize(in))
      if isinteger(in{ii}) | islogical(in{ii})
         in{ii} = dip_image(in{ii},'sfloat');
      end
   end
end
l = zeros(imarsize(in));
for ii=1:prod(imarsize(in))
   if islogical(in{ii})
      in{ii} = +in{ii};
      l(ii) = 1;
   end
end
switch ndims(in{1})
   case 2
      %#function dip_rotation
      out = iterate('dip_rotation',in,angle,method,bgval);
   case 3
      %#function dip_rotation3d_axis
      out = iterate('dip_rotation3d_axis',in,angle,axis-1,method,bgval);
   otherwise
      error('Rotation only supported for 2D/3D images.');
end
if any(l)
   for ii=1:prod(imarsize(in))
      if l(ii)
         out{ii} = dip_image(out{ii},'bin');
      end
   end
end
