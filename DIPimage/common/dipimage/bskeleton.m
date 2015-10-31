%BSKELETON   Binary skeleton
%
% SYNOPSIS:
%  image_out = bskeleton(image_in,edgeCondition,endPixelCondition)
%
% PARAMETERS:
%  endPixelCondition: 'looseendsaway', 'natural', '1neighbor',
%                     '2neighbors', '3neighbors'
%
% DEFAULTS 2D:
%  edgeCondition = 0
%  endPixelCondition = 'natural'
%
% WARNINGS
%  The algorithm uses a 2-pixel thick border at the edges of the image. This
%  affects results on objects within this area. EXTEND the image with a dummy
%  border if this is a problem for you.
%
%  This function is only defined for 2D and 3D images.
%
%  The 3D version of this algorithm is buggy, 'looseendsaway', '1neighbor' and
%  '3neighbors' all produce the same result. Wrong skeletons are returned by
%  the different modes under various circumstances.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% 17 October 2008: Added warnings to the help. (CL)

function image_out = bskeleton(varargin)

d = struct('menu','Binary Filters',...
           'display','Binary skeleton',...
           'inparams',struct('name',       {'image_in',   'edgeCondition', 'endPixelCondition'},...
                             'description',{'Input image','Edge Condition','End-pixel Condition'},...
                             'type',       {'image',      'option',        'option'},...
                             'dim_check',  {0,            0,               0},...
                             'range_check',{'bin',        {0,1},           {'looseendsaway', 'natural', '1neighbor', '2neighbors', '3neighbors'}},...
                             'required',   {1,            0,               0},...
                             'default',    {'a',          0,               'natural'}...
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
   [image_in,edgeCondition,endPixelCondition] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_euclideanskeleton(image_in,endPixelCondition,edgeCondition);
