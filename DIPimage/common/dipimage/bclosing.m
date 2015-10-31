%BCLOSING   Binary closing
%
% SYNOPSIS:
%  image_out = bclosing(image_in,iterations,connectivity,edgeCondition)
%
% PARAMETERS:
%  iterations: the number of steps taken, defines the size of the
%     structuring element.
%  connectivity: defines the metric, that is, the shape of the structuring
%     element.
%     * 1 indicates city-block metric, or a diamond-shaped S.E.
%     * 2 indicates chessboard metric, or a square structuring element.
%     * -1 indicates alternating connectivity: first 1, then 2, then 1
%     again, etc. -2 is the same but starting with 2. These produce an
%     octagonal structuring element.
%     For 3D images use 1, 2, 3 or -1, -3. Negative connectivities alternate
%     1 and 3 to obtain a more isotropic structuring element.
%  edgeCondition: defines the value of the pixels outside the image. It
%     can be 0,1 or -1. Negative edgeCondition alters the edgeCondition between
%     the dilation 0 and erosion 1. 
%
% DEFAULTS:
%  iterations = 1
%  connectivity = -1
%  edgeCondition = 1

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% 15 February 2005 - Added negative connectivity for 3D images (CL).
% Dec 2005 - Added edge condition -1 (BR)

function image_out = bclosing(varargin)

d = struct('menu','Binary Filters',...
           'display','Binary closing',...
           'inparams',struct('name',       {'image_in',   'iterations','connectivity','edgeCondition'},...
                             'description',{'Input image','Iterations','Connectivity','Edge Condition'},...
                             'type',       {'image',      'array',     'array',       'option'},...
                             'dim_check',  {0,            0,           0,             0},...
                             'range_check',{'bin',        'N+',        [-3 3],        {0,1,-1}},...
                             'required',   {1,            0,           0,             0},...
                             'default',    {'a',          1,           -1,            1}...
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
   [image_in,iterations,connectivity,edgeCondition] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_binaryclosing(image_in,connectivity,iterations,edgeCondition);
