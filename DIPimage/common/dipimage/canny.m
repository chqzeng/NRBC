%CANNY   Canny edge detector
%
% SYNOPSIS:
%  image_out = canny(image_in,sigma,lower,upper)
%
% PARAMETERS:
%  sigma: sigma of Gaussian derivatives
%  lower: lower threshold fraction (between 0 and 1)
%  upper: upper threshold fraction (between 0 and 1)
%
% DEFAULTS:
%  sigma = 1
%  lower = 0.5
%  upper = 0.9
%
% LITERATURE:
%  J. Canny, A Computational Approach to Edge Detection,
%  IEEE Transactions on Pattern Analysis and Machine Intelligence,
%  8(6):679-697, 1986.

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, July 2003.
% 13 July 2010: Now calling the DIPlib version of the (exact) same code (CL).

function out=canny(varargin);

d = struct('menu','Segmentation',...
    'display','Canny filter',...
    'inparams',struct('name',       {'image_in',   'sigma','lower','upper'},...
                      'description',{'Input image','Sigma','lower threshold fraction','upper threshold fraction'},...
                      'type',       {'image',      'array','array',           'array'},...
                      'dim_check',  {0,            0,       0,                 0},...
                      'range_check',{[],           'R+',    [0 1],             [0 1]},...
                      'required',   {1,            0,       0,                 0},...
                      'default',    {'a',          1.0,     0.5,               0.9}...
                      ),...
    'outparams',struct('name',{'image_out'},...
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
try
   [in,sigma,lowerfrac,upperfrac] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = dip_canny(in,sigma,lowerfrac,upperfrac);

% MIKE'S OLD CODE:
% drx = dx(in,sigma);
% dry = dy(in,sigma);
% drm = sqrt(drx^2+dry^2);
% drm = dip_nonmaximumsuppression(drm,drx,dry,[]);
% tlevel = percentile(drm,upperfrac*100);
% drm = bpropagation(drm>tlevel,drm>(lowerfrac*tlevel),0,2,0);
% out = bskeleton(drm,0,'natural');
