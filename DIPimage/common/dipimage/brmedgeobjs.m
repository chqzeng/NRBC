%BRMEDGEOBJS   Remove edge objects from binary image
%
% SYNOPSIS:
%  image_out = brmedgeobjs(image_in,connectivity)
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
%
% DEFAULTS:
%  connectivity = 1

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function image_out = brmedgeobjs(varargin)

d = struct('menu','Binary Filters',...
           'display','Remove edge objects',...
           'inparams',struct('name',       {'image_in',   'connectivity'},...
                             'description',{'Input image','Connectivity'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {0,            0},...
                             'range_check',{'bin',        [1 3]},...
                             'required',   {1,            0},...
                             'default',    {'a',          1}...
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
   [image_in,connectivity] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_edgeobjectsremove(image_in,connectivity);
