%LABEL   Label objects in a binary image
%
% SYNOPSIS:
%  image_out = label(image_in,connectivity,minSize,maxSize)
%
% PARAMETERS:
%  connectivity: defines which pixels are considered neighbours: up to
%     'connectivity' coordinates can differ by maximally 1. Thus:
%     * A connectivity of 1 indicates 4-connected neighbours in a 2D image
%       and 6-connected in 3D.
%     * A connectivity of 2 indicates 8-connected neighbourhood in 2D, and
%       18 in 3D.
%     * A connectivity of 3 indicates a 26-connected neighbourhood in 3D.
%     Connectivity can never be larger than the image dimensionality. Setting
%     the connectivity to Inf (the default) makes it equal to the image
%     image dimensionality.
%  minSize, maxSize: minimum and maximum size of objects to be labeled.
%
% DEFAULTS:
%  connectivity = inf
%  minSize = 0
%  maxSize = 0

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, September 2000.
% 26 March 2009:  connectivity==inf => connectivity=ndims(image_in).

function [image_out, varargout] = label(varargin)

d = struct('menu','Segmentation',...
           'display','Label objects',...
           'inparams',struct('name',       {'image_in',   'connectivity','minSize',            'maxSize'},...
                             'description',{'Input image','Connectivity','Minumum object size','Maximum object size'},...
                             'type',       {'image',      'array',      'array',              'array'},...
                             'dim_check',  {0,            0,             0,                    0},...
                             'range_check',{'bin',        'N+',          'N',                  'N'},...
                             'required',   {1,            0,             0,                    0},...
                             'default',    {'a',          inf,           0,                    0}...
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
   [image_in,connectivity,minSize,maxSize] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if isinf(connectivity)
   connectivity = ndims(image_in);
end
[image_out,nol] = dip_label(image_in,connectivity,'threshold_on_size',minSize,maxSize,'');
varargout{1}=nol;
