%HITMISS   Hit-miss operator
%
% SYNOPSIS:
%  image_out = hitmiss(image_in,se)
%
% PARAMETERS:
%  se: image with the mask. It must only contain 0, 1 and NaN values.
%      NaN represents the 'don't care', 0 is background, 1 is foreground.
%      Any other value is converted to NaN.

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2002.

function image_out = hitmiss(varargin)

d = struct(...
   'menu','Binary Filters',...
   'display','Hit-miss operator',...
   'inparams',struct(...
      'name',       {'image_in',   'se'},...
      'description',{'Input image','Structuring element'},...
      'type',       {'image',      'image'},...
      'dim_check',  {0,            0},...
      'range_check',{'bin',        []},...
      'required',   {1,            1},...
      'default',    {'a',          'b'}...
      ),...
   'outparams',struct(...
      'name',       {'image_out'},...
      'description',{'Output image'},...
      'type',       {'image'}...
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
   [image_in,se] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

fp = ones(ndims(image_in),1);
tmp1 = ~dip_dilation(image_in,se==0,fp,'user_defined');
tmp2 = dip_erosion(image_in,se==1,fp,'user_defined');
image_out = tmp1 & tmp2;
