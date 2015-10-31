%RANKMAX_OPENING   Rank-max opening
%
% SYNOPSIS:
%  image_out = opening(image_in,percentile,filterSize,filterShape)
%
% PARAMETERS:
%  percentile: percentile of pixels to remain in the filter.
%  filterShape: 'rectangular', 'elliptic', 'diamond'
%
% DEFAULTS:
%  percentile = 90
%  filterSize = 7
%  filterShape = 'elliptic'
%
% EXAMPLE:
%  x = zeros(39,39);
%  x(20,20) = 1;
%  x = 1-dip_image(noise((dilation(x,20,'elliptic') > 0),'binary',0.04,0),'uint8');
%  y = rankmax_opening(x,20,3,'rectangular');
%
% NOTE:
%  This function uses the definition of Soille:
%     \gamma_{B,\lambda} = \bigvee_i \{ \gamma_{B_i} | B_i \bigcup
%     \{ p_1,p_2,\ldots,\p_{n-\lambda} \} = B \}
%  this is identical to:
%     \gamma_{B,\lambda} = I \bigwedge \delta_{\v{B}} \xi_{B,n-\lambda+1}

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Richard van den Doel, February 2002.

function image_out = rankmax_opening(varargin)

d = struct('menu','Morphology',...
           'display','Rank-max opening',...
           'inparams',struct('name',       {'image_in',   'percentile',    'filterSize',    'filterShape'},...
                             'description',{'Input image','Percentile',    'Size of filter','Shape of filter'},...
                             'type',       {'image',      'array',         'array',         'option'},...
                             'dim_check',  {0,            0,               1,               0},...
                             'range_check',{[],           [0,100],         'R+',            {'rectangular','elliptic','diamond'}},...
                             'required',   {1,            0,               0,               0},...
                             'default',    {'a',          90,              7,               'elliptic'}...
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
   [image_in,perc,filterSize,filterShape] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% This computes the rank order erosion:
image_out = dip_percentilefilter(image_in,[],filterSize,filterShape,100-perc);

% this computes the dilation \delta_{\v{B}}:
% se = mirror(se,'point'); % The structuring elements are symmetric
image_out = dip_dilation(image_out,[],filterSize,filterShape);

% This computes the infimum I \bigwedge \delta_{\v{B}} \xi_{B,n-\lambda+1}:
image_out = min(image_in,image_out);
