%KUWAHARA   Kuwahara filter for edge-preserving smoothing
%
% SYNOPSIS:
%  image_out = kuwahara(image_in,filterSize,filterShape,threshold)
%
% PARAMETERS:
%  filterShape: 'rectangular', 'elliptic', 'diamond'
%  threshold:   minimum variance difference to shift kernel
%
% DEFAULTS:
%  filterSize = 7
%  filterShape = 'elliptic'
%  threshold = 0

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.

function image_out = kuwahara(varargin)

d = struct('menu','Adaptive Filters',...
           'display','Kuwahara filter',...
           'inparams',struct('name',       {'image_in',   'filterSize',    'filterShape',    'threshold'},...
                             'description',{'Input image','Size of filter','Shape of filter','Threshold'},...
                             'type',       {'image',      'array',         'option',         'array'},...
                             'dim_check',  {0,            1,               0,                [1,1]},...
                             'range_check',{[],           'R+',            {'rectangular','elliptic','diamond'},'R+'},...
                             'required',   {1,            0,               0,                0},...
                             'default',    {'a',          7,               'elliptic',       0}...
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
   [image_in,filterSize,filterShape,threshold] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_kuwaharaimproved(image_in,[],filterSize,filterShape,threshold);
