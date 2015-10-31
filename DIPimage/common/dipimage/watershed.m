%WATERSHED   Watershed
%
% SYNOPSIS:
%  image_out = watershed(image_in,connectivity,max_depth,max_size)
%
% PARAMETERS:
%  connectivity: defines which pixels are considered neighbours: up to
%     'connectivity' coordinates can differ by maximally 1. Thus:
%     * A connectivity of 1 indicates 4-connected neighbours in a 2D image
%       and 6-connected in 3D.
%     * A connectivity of 2 indicates 8-connected neighbourhood in 2D, and
%       18 in 3D.
%     * A connectivity of 3 indicates a 26-connected neighbourhood in 3D.
%     Connectivity can never be larger than the image dimensionality.
%  max_depth, max_size: determine merging of regions.
%     A region up to 'max_size' pixels and up to 'max_depth' grey-value
%     difference will be merged.
%
% DEFAULTS:
%  connectivity = 1
%  max_depth = 0 (only merging within plateaus)
%  max_size = 0 (any size)
%
% NOTE:
%  If there are plateaus in the image (regions with constant grey-value),
%  this function will produce poor results. A more correct watershed
%  algorithm (albeit slower) is
%     seeds = minima(image_in,connectivity,0);
%     image_out = waterseed(seeds,image_in,connectivity,max_depth,max_size);
%
% NOTE 2:
%  This algorithm skips all edge pixels, marking them as watershed pixels.
%  The seeded watershed algorithm WATERSEED does not do this (and hence is
%  slower).
%
% NOTE 3:
%  Pixels in IMAGE_IN with a value of +INF are not processed, and will be
%  marked as watershed pixels. Use this to mask out parts of the image you
%  don't need processed.
%
% SEE ALSO:
%  waterseed

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.
% 17 February 2005 - Added some comments to the help.
% 23 July 2008     - Added information on MINIMA and WATERSEED.
% 11 November 2009 - Added masking of +Inf pixels.

function image_out = watershed(varargin)

d = struct('menu','Segmentation',...
           'display','Watershed',...
           'inparams',struct('name',       {'image_in',   'connectivity','max_depth',                'max_size'},...
                             'description',{'Input image','Connectivity','Maximum depth for merging','Maximum size for merging'},...
                             'type',       {'image',      'array',       'array',                    'array'},...
                             'dim_check',  {0,            0,             0,                          0},...
                             'range_check',{[],           'N+',          'R+',                       'N'},...
                             'required',   {1,            0,             0,                          0},...
                             'default',    {'a',          1,             0,                          0}...
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
   [image_in,connectivity,max_depth,max_size] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

mask = image_in<Inf;

image_out = dip_watershed(image_in,mask,connectivity,max_depth,max_size,1);
