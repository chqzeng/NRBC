%RANKMIN_CLOSING   Rank-min closing
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
%  x = dip_image(noise((dilation(x,20,'elliptic') > 0),'binary',0.04,0),'uint8');
%  y = rankmin_closing(x,80,3,'rectangular');
%
% NOTES:
%  This function uses the definition of Soille:
%     \phi_{B,\lambda} = \bigwedge_i \{ \phi_{B_i} | B_i \bigcup
%     \{ p_1,p_2,\ldots,\p_{n-\lambda} \} = B \}
%  this is identical to:
%     \phi_{B,\lambda} = I \bigvee \epsilon_{\v{B}} \xi_{B,\lambda}
%
%  The result of this function is influenced by DIP_MORPH_FLAVOUR.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Richard van den Doel, February 2002.

function image_out = rankmin_closing(varargin)

d = struct('menu','Morphology',...
           'display','Rank-min closing',...
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

% This computes the rank order dilation:
image_out = dip_percentilefilter(image_in,[],filterSize,filterShape,perc);

% this computes the erosion \delta_{\v{B}}:
% se = mirror(se,'point'); % The structuring elements are symmetric
image_out = dip_erosion(image_out,[],filterSize,filterShape);

% This computes the supremum I \bigvee \epsilon_{\v{B}} \xi_{B,\lambda}:
image_out = max(image_in,image_out);
