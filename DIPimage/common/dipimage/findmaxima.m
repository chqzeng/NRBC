%FINDMAXIMA   Find local maxima
%
% FINDMAXIMA returns a list of coordinates of local maxima in the input
% image, with sub-pixel precision.
%
% SYNOPSIS:
%  [coords,vals] = findmaxima(image_in,method)
%
% PARAMETERS:
%  method: determines the method to use, can be one of: 'linear',
%      'parabolic', 'gaussian', 'bspline', 'parabolic_nonseparable', or
%      'gaussian_nonseparable'.
%  coords: array of size N by ndims(image_in), where N is the number
%      of detected local maxima.
%  vals: optional output array of size N by 1, with the interpolated
%      values of image_in at coords.
%
% DEFAULTS:
%  method = 'parabolic';
%
% EXAMPLE: Harris corner detector with subpixel accuracy:
%   a = readim;
%   g = gradient(a);
%   t = gaussf(g*g',3);
%   c = det(t)-0.1*trace(t)^2;
%   [p,v] = findmaxima(c);
%   p(v<0.0001*max(v),:) = [];
%   dipshow(a), hold on
%   plot(p(:,1),p(:,2),'r+')
%
% SEE ALSO:
%  maxima, findminima, subpixlocation

% (C) Copyright 2010, Cris Luengo.
% Written 23 July 2010.

function [coords,vals] = findmaxima(varargin)

options = struct('name',{'linear','parabolic','gaussian','bspline',...
                         'parabolic_nonseparable','gaussian_nonseparable'},...
                 'description',{'Center of gravity over 3 pixels',...
                                'Parabolic fit over 3 pixels',...
                                'Gaussian fit over 3 pixels',...
                                'Bspline interpolation over 11 pixels',...
                                'Parabolic fit, 2D or 3D images only',...
                                'Gaussian fit, 2D or 3D images only'});
d = struct('menu','Analysis',...
           'display','Find local maxima',...
           'inparams',struct('name',       {'image_in',   'method'},...
                             'description',{'Input image','Sub-pixel method'},...
                             'type',       {'image',      'option'},...
                             'dim_check',  {0,            0},...
                             'range_check',{[],           options},...
                             'required',   {1,            0},...
                             'default',    {'a',          'parabolic'}...
                            ),...
           'outparams',struct('name',{'coords','vals'},...
                              'description',{'Output coordinate array','Output grey value array'},...
                              'type',{'array','array'}...
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

m = min(image_in);
m = image_in~=m;
if sum(m) > (prod(imsize(m))*0.9)
   m = [];
end
% m contains a mask if there is a large plateau with minimum value.
% This will speed up the function quite a bit.
[coords,vals] = dip_subpixelmaxima(image_in,m,method);
