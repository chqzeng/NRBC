%RADIALMIN   Computes the minimum as a function of the R-coordinate
%
% SYNOPSIS:
%  image_out = radialmin(image_in,[mask],binSize,innerRadius)
%
% PARAMETERS:
%  image_in:    the input image
%  mask:        binary mask image (OPTIONAL)
%  binSize:     the size of the radial bins
%  innerRadius: the maximum radius to use: the smallest or largest radius
%               that fits the image
%
% DEFAULTS:
%  binSize = 1
%  innerRadius = 0
%
% NOTE:
%  The center of the image, around which the measurements are done, is
%  the same one as defined by the Fourier Transform. That is, on even
%  size, it is to the right of the true center. This is also the default
%  for functions like RR.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2001.
% 18 August 2009:    Added optional MASK parameter.

function image_out = radialmin(varargin)

d = struct('menu','Statistics',...
           'display','Radial minimum',...
           'inparams',struct('name',       {'image_in',   'mask',      'binSize',        'innerRadius'},...
                             'description',{'Input image','Mask image','Radial bin size','Use inner radius'},...
                             'type',       {'image',      'image',     'array',          'boolean'},...
                             'dim_check',  {0,            0,           0,                []},...
                             'range_check',{[],           [],          'R+',             []},...
                             'required',   {1,            0,           0,                0},...
                             'default',    {'a',          '[]',        1,                0}...
                              ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
if nargin>=2
   s = varargin{2};
   if isnumeric(s) & prod(size(s))==1
      % This looks like the BINSIZE parameter, the user skipped the MASK parameter
      varargin = [varargin(1),{[]},varargin(2:end)];
   end
end
try
   [image_in,mask,binSize,innerRadius] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_radialminimum(image_in,mask,[],binSize,innerRadius,[]);
