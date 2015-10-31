%GABOR_CLICK  Gabor filter
%
% SYNOPSIS:
%  image_out = gabor_click(image_in,sigma,figh)
%
% PARAMETERS:
%  image_in = ORIGINAL image
%  sigma = sigma in the spatial domain
%  figh = figure handle for FOURIER image in which to select a position
%
%  Click on the the pixel position in the FOURIER image where you want to
%   apply the filter.
%
% DEFAULTS:
%  sigma = 5
%  figh = gcf (the current figure)

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Oct 2000.
% 29 July 2001: Added FIGH parameter.
% 20 Aug 2001: print selected frequencies
% 06 Dec 2006: added printing of spatial parameters (angle and length scale)
% 3 March 2009: Produce error when user right-clicks. (CL)

function image_out = gabor_click(varargin)

d = struct('menu','Filters',...
    'display','Gabor filter',...
    'inparams',struct('name',       {'image_in',   'sigma','figh'},...
                      'description',{'Input image','Sigma','Figure with Fourier image'},...
                      'type',       {'image',      'array','handle'},...
                      'dim_check',  {0,            1,      0},...
                      'range_check',{[],           'R+',   []},...
                      'required',   {1,            0,      0},...
                      'default',    {'a',          5,      []}...
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
   [image_in,sigma,figh] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ndims(image_in)~=2
   error('Gabor_click only impelemented for 2 dimensional images, use dip_gaboriir.');
end

x = dipgetcoords(figh,1);
if x(1)<0  % dipgetcoords returns [-1,-1] when right-clicking
   error('Cancelled.');
end
sz = size(image_in);
f = (x-(sz/2))./sz;

process = ones(size(sigma));
order = zeros(size(sigma));

fprintf('Selected frequencies: %f %f [cartesian]\n',f);
fprintf('Spatial pattern: distance %f [pix], angle: %f [deg]\n',1/norm(f),atan2(f(2),f(1))*180/pi + 90);
%Note: angle is mathematically positive on left turn, but y-axis is down
%and Fourier is 90deg rotated
image_out = dip_gaboriir(image_in,process,sigma,f,order);
