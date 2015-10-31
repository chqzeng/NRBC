%ERFCLIP   Grey-value error function clipping
%  soft clipping between: threshold +- range/2 
%
% SYNOPSIS:
%  image_out = erfclip(image_in,threshold,range)
%
% DEFAULTS:
%  threshold = 128
%  range = 64

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, October 2000.

function image_out = erfclip(varargin)

d = struct('menu','Point',...
           'display','Grey-value error function clipping',...
           'inparams',struct('name',       {'image_in',   'threshold', 'range'},...
                             'description',{'Input image','Threshold', 'Range'},...
                             'type',       {'image',      'array',     'array'},...
                             'dim_check',  {0,            0,           0},...
                             'range_check',{[],           [],          []},...
                             'required',   {1,            0,           0},...
                             'default',    {'a',          128,         64}...
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
   [image_in,threshold,range] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
image_out = dip_erfclip(image_in,threshold,range,'both');
