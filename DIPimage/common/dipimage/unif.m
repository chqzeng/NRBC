%UNIF   Uniform filter
%
% SYNOPSIS:
%  image_out = unif(image_in,filterSize,filterShape)
%
% PARAMETERS:
%  filterShape: 'rectangular', 'elliptic', 'diamond'
%
% WARNING:
%  Unlike most other linear filters (e.g. gaussf) the
%  output is not by definition in floating point. In
%  case of integer valued input, the result is rounded
%  and then returned as an integer image. If you want
%  the floating point output, use unif(1*image_in).
%
% DEFAULTS:
%  filterSize = 7
%  filterShape = 'elliptic'

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% 30 July 2009:   Allowing tensor input.
function image_out = unif(varargin)

d = struct('menu','Filters',...
           'display','Uniform filter',...
           'inparams',struct('name',       {'image_in',   'filterSize',    'filterShape'},...
                             'description',{'Input image','Size of filter','Shape of filter'},...
                             'type',       {'image',      'array',         'option'},...
                             'dim_check',  {[],           1,               0},...
                             'range_check',{{'tensor','noncomplex'},'R+',  {'rectangular','elliptic','diamond'}},...
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

%#function dip_uniform
image_out = iterate('dip_uniform',image_in,[],filterSize,filterShape);
