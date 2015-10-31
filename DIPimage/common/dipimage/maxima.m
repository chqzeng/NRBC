%MAXIMA   Detect local maxima
%
% MAXIMA returns a binary image with pixels set that belong to local maxima
% of the input.
%
% SYNOPSIS:
%  image_out = maxima(image_in,connectivity,binary_output)
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
%  binary_output: set to FALSE to return a labelled output image.
%
% DEFAULTS:
%  connectivity = 1
%  binary_output = TRUE
%
% NOTE:
%  a = maxima(in,2,false)
%  is equivalent to
%  a = label(maxima(in,2,true),2)
%
% SEE ALSO:
%  minima

% (C) Copyright 2008                    Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2008.

function image_out = maxima(varargin)

d = struct('menu','Segmentation',...
           'display','Detect local maxima',...
           'inparams',struct('name',       {'image_in',   'connectivity','binary_output'},...
                             'description',{'Input image','Connectivity',''},...
                             'type',       {'image',      'array',       'boolean'},...
                             'dim_check',  {0,            0,             0},...
                             'range_check',{[],           'N+',          0},...
                             'required',   {1,            0,             0},...
                             'default',    {'a',          1,             'yes'}...
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
   [image_in,connectivity,binary_output] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_maxima(image_in,[],connectivity,binary_output);
