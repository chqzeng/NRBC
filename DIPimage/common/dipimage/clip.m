%CLIP   Grey-value clipping
%
% SYNOPSIS:
%  image_out = clip(image_in,maximum,minimum)
%
% DEFAULTS:
%  maximum = 255
%  minimum = 0
%
% NOTES:
%  Maximum and minimum may be reversed.
%
%  Set Maximum to Inf or Minimum to -Inf to do a one-sided clip.

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% 8 June 2001:     Now using dip_clip instead of comparisons and masking.
% 24 October 2006: Added one-sided clipping flagged with INF.

function image_out = clip(varargin)

d = struct('menu','Point',...
           'display','Grey-value clipping',...
           'inparams',struct('name',       {'image_in',   'maximum',   'minimum'},...
                             'description',{'Input image','Maximum',   'Minimum'},...
                             'type',       {'image',      'array',     'array'},...
                             'dim_check',  {0,            0,           0},...
                             'range_check',{[],           [],          []},...
                             'required',   {1,            0,           0},...
                             'default',    {'a',          255,         0}...
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
   [image_out,maximum,minimum] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if minimum > maximum
   tmp = minimum; minimum = maximum; maximum = tmp;
end
if ~isfinite(minimum)
   image_out = iterate('dip_clip',image_out,minimum,maximum,'high');
elseif ~isfinite(maximum)
   image_out = iterate('dip_clip',image_out,minimum,maximum,'low');
else
   image_out = iterate('dip_clip',image_out,minimum,maximum,'both');
end
