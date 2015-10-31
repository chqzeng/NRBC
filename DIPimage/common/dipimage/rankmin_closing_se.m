%RANKMIN_CLOSING_SE   Rank-min closing with user defined structuring element
%
% SYNOPSIS:
%  image_out = opening(image_in,se,percentile)
%
% PARAMETERS:
%  se: binary image with the shape for the structuring element
%  percentile: percentile of pixels to remain in the filter.
%
% DEFAULTS:
%  percentile = 90
%
% EXAMPLE:
%  x = zeros(39,39);
%  x(20,20) = 1;
%  x = dip_image(noise((dilation(x,20,'elliptic') > 0),'binary',0.04,0),'uint8');
%  SE = dip_image([0 1 0;1 1 1;0 1 0],'bin');
%  y = rankmin_closing_se(x,SE,100);
%
% NOTE:
%  This function uses the definition of Soille:
%     \phi_{B,\lambda} = \bigwedge_i \{ \phi_{B_i} | B_i \bigcup
%     \{ p_1,p_2,\ldots,\p_{n-\lambda} \} = B \}
%  this is identical to:
%     \phi_{B,\lambda} = I \bigvee \epsilon_{\v{B}} \xi_{B,\lambda}

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Richard van den Doel, February 2002.
% Input auto convert to bin (BR) March 2002
% 15 November 2002: 'bin8' => 'bin'

function image_out = rankmin_closing_se(varargin)

d = struct('menu','Morphology',...
           'display','Custom rank-min closing',...
           'inparams',struct('name',       {'image_in',   'se',                 'percentile'},...
                             'description',{'Input image','Structuring element','Percentile'},...
                             'type',       {'image',      'image',              'array'},...
                             'dim_check',  {0,            0,                    0},...
                             'range_check',{'noncomplex', 'bin',                [0,100]},...
                             'required',   {1,            1,                    0},...
                             'default',    {'a',          'b',                  90}...
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
   [image_in,se,perc] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ndims(image_in)~=ndims(se)
   error('SE must have same dimensionality as image')
end
if dipgetpref('MorphologicalFlavour') == 2
   se = mirror(se,'point');
end

% this computes the rank order dilation:
image_out = dip_percentilefilter(image_in,se,zeros(ndims(image_in),1),'user_defined',perc);

% this computes the erosion \delta_{\v{B}}:
se = mirror(se,'point');
image_out = dip_erosion(image_out,se,ones(ndims(image_in),1),'user_defined');

% This computes the supremum I \bigvee \epsilon_{\v{B}} \xi_{B,\lambda}:
image_out = max(image_in,image_out);
