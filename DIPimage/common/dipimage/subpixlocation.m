%SUBPIXLOCATION   Find sub-pixel location of extrema
%
% Returns a list of coordinates of local maxima or minima in the
% input image, with sub-pixel precision.
%
% SYNOPSIS:
%  coords = subpixlocation(image_in,coords,method,polarity)
%
% PARAMETERS:
%  coords:   array of size N by ndims(image_in), of N integer locations
%       around which to determine sub-pixel locations.
%  method:   determines the method to use, can be one of: 'linear',
%      'parabolic', 'gaussian', 'bspline', 'parabolic_nonseparable', or
%      'gaussian_nonseparable'.
%  polarity: 'maximum' or 'minimum'.
%
% DEFAULTS:
%  method = 'parabolic';
%
% EXAMPLE:
%  t = findcoord(maxima(a));
%  t = subpixlocation(a,t);
%  % Note that this is the same as:
%  t = findmaxima(a);
%
% SEE ALSO:
%  findmaxima, findminima, maxima, minima

% (C) Copyright 2010, Cris Luengo.
% Written 23 July 2010.

function coords = subpixlocation(varargin)

options = struct('name',{'linear','parabolic','gaussian','bspline',...
                         'parabolic_nonseparable','gaussian_nonseparable'},...
                 'description',{'Center of gravity over 3 pixels',...
                                'Parabolic fit over 3 pixels',...
                                'Gaussian fit over 3 pixels',...
                                'Bspline interpolation over 11 pixels',...
                                'Parabolic fit, 2D or 3D images only',...
                                'Gaussian fit, 2D or 3D images only'});
d = struct('menu','Analysis',...
           'display','Find sub-pixel location of extrema',...
           'inparams',struct('name',       {'image_in',   'coords','method',  'polarity'},...
                             'description',{'Input image','Integer coordinates','Sub-pixel method','Polarity'},...
                             'type',       {'image',      'array', 'option',  'option'},...
                             'dim_check',  {0,            [-1,-1], 0,         0},...
                             'range_check',{[],           'R',     options,   {'maximum','minimum'}},...
                             'required',   {1,            1,       0,         0},...
                             'default',    {'a',          [],      'parabolic','maximum'}...
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
   [image_in,coords,method,pol] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

sz = imsize(image_in);
if size(coords,2)~=length(sz)
   error('COORDS array has the wrong size.');
end
N = size(coords,1);
for ii=1:N
   c = round(coords(ii,:));
   if ~ ( any(c<=0) | any(c>=sz-1) )
      coords(ii,:) = dip_subpixellocation(image_in,c,method,pol);
   end
end
