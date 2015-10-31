%FINDMINIMA   Find local minima
%
% FINDMINIMA returns a list of coordinates of local minima in the input
% image, with sub-pixel precision.
%
% SYNOPSIS:
%  coords = findminima(image_in,method)
%
% PARAMETERS:
%  method: determines the method to use, can be one of: 'linear',
%      'parabolic', 'gaussian', 'bspline', 'parabolic_nonseparable', or
%      'gaussian_nonseparable'.
%  coords: array of size N by ndims(image_in), where N is the number
%      of detected local minima.
%
% DEFAULTS:
%  method = 'parabolic';
%
% SEE ALSO:
%  minima, findmaxima, subpixlocation

% (C) Copyright 2010, Cris Luengo.
% Written 23 July 2010.

function coords = findminima(varargin)

options = struct('name',{'linear','parabolic','gaussian','bspline',...
                         'parabolic_nonseparable','gaussian_nonseparable'},...
                 'description',{'Center of gravity over 3 pixels',...
                                'Parabolic fit over 3 pixels',...
                                'Gaussian fit over 3 pixels',...
                                'Bspline interpolation over 11 pixels',...
                                'Parabolic fit, 2D or 3D images only',...
                                'Gaussian fit, 2D or 3D images only'});
d = struct('menu','Analysis',...
           'display','Find local minima',...
           'inparams',struct('name',       {'image_in',   'method'},...
                             'description',{'Input image','Sub-pixel method'},...
                             'type',       {'image',      'option'},...
                             'dim_check',  {0,            0},...
                             'range_check',{[],           options},...
                             'required',   {1,            0},...
                             'default',    {'a',          'parabolic'}...
                            ),...
           'outparams',struct('name',{'coords'},...
                              'description',{'Output coordinate array'},...
                              'type',{'array'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      coords = d;
      return
   end
end
try
   [image_in,method] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

m = max(image_in);
m = image_in~=m;
if sum(m) > (prod(imsize(m))*0.9)
   m = [];
end
% m contains a mask if there is a large plateau with minimum value.
% This will speed up the function quite a bit.
coords = dip_subpixelminima(image_in,m,method);
