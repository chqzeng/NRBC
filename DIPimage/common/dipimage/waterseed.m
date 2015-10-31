%WATERSEED   Watershed initialized with a seed image
%
% WATERSEED performs a watershed on the image GREY_IMAGE, starting with
% the seeds in the labelled SEED_IMAGE. The labelled regions are grown
% by addressing their neighbors (defined by CONNECTIVITY) in the order
% of the grey-values in GREY_IMAGE, lower first.
%
% SYNOPSIS:
%  image_out = waterseed(seed_image,grey_image,connectivity,max_depth,max_size)
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
%     A region up to 'min_size' pixels and up to 'max_depth' grey-value
%     difference will be merged.
%
% DEFAULTS:
%  connectivity = 1
%  max_depth = 0 (only merging within plateaus)
%  max_size = 0 (any size)
%
% NOTE 1:
%  Two seeds will always be merged if there is no "grey-value barrier"
%  between them. Simply adding a little bit of noise to the image will
%  avoid merging of seeds.
%
% NOTE 2:
%  Pixels in GREY_IMAGE with a value of +INF are not processed, and will be
%  marked as watershed pixels. Use this to mask out parts of the image you
%  don't need processed.
%
% EXAMPLE:
%  a = readim('cermet');
%  b = minima(gaussf(a,10),2,false);
%  c = waterseed(b,a,1);
%  overlay(a,c)
%
% SEE ALSO:
%  watershed, dip_minima, dip_localminima, dip_seededwatershed, dip_growregions

% (C) Copyright 2004-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February 2005.
% 23 July 2008 - Using new function DIP_SEEDEDWATERSHED.
% 11 November 2009 - Added masking of +Inf pixels, and a note on region merging.

function image_out = waterseed(varargin)

d = struct('menu','Segmentation',...
           'display','Watershed with seeds',...
           'inparams',struct('name',       {'seed_image','grey_image','connectivity','max_depth',                'max_size'},...
                             'description',{'Seed image','Grey image','Connectivity','Maximum depth for merging','Maximum size for merging'},...
                             'type',       {'image',     'image',      'array',      'array',                    'array'},...
                             'dim_check',  {0,           0,            0,            0,                          0},...
                             'range_check',{[],          [],           'N+',         'R+',                       'N'},...
                             'required',   {1,           1,            0,            0,                          0},...
                             'default',    {'a',         'b',          1,            0,                          0}...
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
   [seed_image,grey_image,connectivity,max_depth,max_size] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

mask = grey_image<Inf;

image_out = dip_seededwatershed(seed_image,grey_image,mask,connectivity,'low_first',max_depth,max_size,1);
