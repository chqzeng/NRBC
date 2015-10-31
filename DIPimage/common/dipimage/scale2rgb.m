%SCALE2RGB   Convert scale-space to RGB image
%
% SYNOPSIS:
%  image_out = scale2rgb(image_in,red,green,blue,relative)
%
% PARAMETERS:
%  image_in:         3D image with scale along the third axis.
%  red, green, blue: arrays with indices into the third dimension in image_in.
%  relative:         set to true for scaling of intensity values per pixel.

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.
% 19 October 2001: Fixed some bugs.
% 27 November 2003: Added 'relative' parameter to help.

function image_out = scale2rgb(varargin)

d = struct('menu','Analysis',...
           'display','Convert scale-space to RGB image',...
           'inparams',struct('name',       {'image_in',   'red',  'green','blue', 'relative'},...
                             'description',{'Input image','Indices for red component','Indices for green component','Indices for blue component','Saturate each pixel'},...
                             'type',       {'image',      'array','array','array','boolean'},...
                             'dim_check',  {0,            -1,    -1,      -1,0},...
                             'range_check',{[],           'N',   'N',     'N',    []},...
                             'required',   {1,            0,     0,       0,      0},...
                             'default',    {'a',          3,     2,       1,      0}...
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
try
   [image_in,red,green,blue,relative] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(image_in) ~= 3
   error('Input image must have three dimensions.')
end
M = size(image_in,3)-1;
red = red(:);
green = green(:);
blue = blue(:);
if isempty(red) | isempty(green) | isempty(blue)
   error('Indices must be provided.');
end
tmp = [red;green;blue];
if any(tmp>M) | any(tmp<0)
   error('Index exceeds image dimensions.')
end
red = squeeze(sum(image_in(:,:,red),[],3));
green = squeeze(sum(image_in(:,:,green),[],3));
blue = squeeze(sum(image_in(:,:,blue),[],3));
val = min([min(red),min(green),min(blue)]);
if val~=0
   red = red-val;
   green = green-val;
   blue = blue-val;
end
if relative
   val = (red+green+blue)*(1/255);
   val(val==0) = 1;
   val = 1/val;
   red = dip_image(red*val,'uint8');
   green = dip_image(green*val,'uint8');
   blue = dip_image(blue*val,'uint8');
else
   val = 255/percentile([red,green,blue],95);
   red = dip_image(red*val,'uint8');
   green = dip_image(green*val,'uint8');
   blue = dip_image(blue*val,'uint8');
end
image_out = joinchannels('RGB',red,green,blue);
image_out = dip_image(image_out,'uint8');
