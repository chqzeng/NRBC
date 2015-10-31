%PERCF   Percentile filter
%
% SYNOPSIS:
%  image_out = percf(image_in,percentile,filterSize,filterShape)
%
% PARAMETERS:
%  filterShape: 'rectangular', 'elliptic', 'diamond'
%
% DEFAULTS:
%  percentile = 50
%  filterSize = 7
%  filterShape = 'elliptic'

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.

function image_out = percf(varargin)

d = struct('menu','Filters',...
           'display','Percentile filter',...
           'inparams',struct('name',       {'image_in',   'percentile',    'filterSize',    'filterShape'},...
                             'description',{'Input image','Percentile',    'Size of filter','Shape of filter'},...
                             'type',       {'image',      'array',         'array',         'option'},...
                             'dim_check',  {[],           0,               1,               0},...
                             'range_check',{{'scalar','real'},[0,100],     'R+',            {'rectangular','elliptic','diamond'}},...
                             'required',   {1,            0,               0,               0},...
                             'default',    {'a',          50,              7,               'elliptic'}...
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
   [image_in,percentile,filterSize,filterShape] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_percentilefilter(image_in,[],filterSize,filterShape,percentile);
