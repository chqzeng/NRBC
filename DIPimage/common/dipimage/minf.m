%MINF   Minimum filter
%
% SYNOPSIS:
%  image_out = minf(image_in,filterSize,filterShape)
%
% PARAMETERS:
%  filterShape: 'rectangular', 'elliptic', 'diamond'
%
% DEFAULTS:
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

function image_out = minf(varargin)

d = struct('menu','Filters',...
           'display','Minimum filter',...
           'inparams',struct('name',       {'image_in',   'filterSize',    'filterShape'},...
                             'description',{'Input image','Size of filter','Shape of filter'},...
                             'type',       {'image',      'array',         'option'},...
                             'dim_check',  {[],           1,               0},...
                             'range_check',{{'scalar','noncomplex'},'R+',  {'rectangular','elliptic','diamond'}},...
                             'required',   {1,            0,               0},...
                             'default',    {'a',          7,               'elliptic'}...
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
   [image_in,filterSize,filterShape] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

image_out = dip_erosion(image_in,[],filterSize,filterShape);
