%GABOR   Gabor filter
%
% SYNOPSIS:
%  image_out = gabor(image_in, sigma, frequency, direction)
%
% PARAMETERS:
%  sigma = sigma in the spatial domain
%  frequency = magnitude of the frequency in pixel [0, 0.5]
%  direction = direction in the fourier domain where to filter [0,2pi]
%    (compare polar coordinates)
%
%  coordinate system in fourier domain:
%     (0,0)=(image size/2, image size/2), i.e. the centre of the image
%     positive x left, positive y down
%     angle: from positive x axis, mathematical left turing
%
% DEFAULTS:
%  sigma = 5
%  frequency = 0.1
%  direction = pi
%
% If you wish to use cartesian coordinates see: dip_gaboriir

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Oct 2000.
% Michael van Ginkel, Nov 2001, changed frequency definition to [0,0.5]

function image_out = gabor(varargin)

if nargin==0
   if exist('private/Gabor.jpg','file')
      image_out = dip_image(imread('private/Gabor.jpg'));
      return
   end
end

d = struct('menu','Filters',...
    'display','Gabor filter',...
    'inparams',struct('name',       {'image_in',   'sigma','frequency',       'direction'},...
                      'description',{'Input image','Sigma','Frequency [0,0.5]','Direction [0,2PI]'},...
                      'type',       {'image',      'array','array',           'array'},...
                      'dim_check',  {0,            1,       0,                 0},...
                      'range_check',{[],           'R+',    'R+',              [0 2*pi]},...
                      'required',   {1,            0,       0,                 0},...
                      'default',    {'a',          5,       .1,                pi}...
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
   [image_in,sigma,frequency,direction] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ndims(image_in)~=2
   error('Gabor only implemented for 2 dimensional images, use dip_gaboriir.');
end
if (frequency>=0.5)
   error('frequency >= 0.5');
end

process = ones(size(sigma));
order = zeros(size(sigma));
f = frequency.*[cos(direction),sin(direction)];
image_out = dip_gaboriir(image_in,process,sigma,f,order);
