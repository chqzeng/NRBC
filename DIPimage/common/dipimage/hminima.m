%HMINIMA   H-minima transform
%
% SYNOPSIS:
%  image_out = hminima(image_in,h,connectivity)
%
% PARAMETERS:
%  h:            the algorithm removes minima with a depth `h` or less.
%  connectivity: defines the metric, that is, the shape of the structuring
%     element.
%     * 1 indicates city-block metric, or a diamond-shaped S.E.
%     * 2 indicates chessboard metric, or a square structuring element.
%     * -1 indicates alternating connectivity: first 1, then 2, then 1
%     again, etc. -2 is the same but starting with 2. These produce an
%     octagonal structuring element.
%     For 3D images use 1, 2, 3 or -1, -3. Negative connectivities alternate
%     1 and 3 to obtain a more isotropic structuring element.
%
% DEFAULTS:
%  connectivity = 1

% (C) Copyright 2013, Cris Luengo
% Centre for Image Analysis, Uppsala, Sweden

function out = hmaxima(varargin)

d = struct('menu','Morphology',...
           'display','H-maxima transform',...
           'inparams',struct('name',       {'image_in',   'h',    'connectivity'},...
                             'description',{'Input image','h',    'Connectivity'},...
                             'type',       {'image',      'array','array'},...
                             'dim_check',  {0,            0,      0},...
                             'range_check',{[],           'R+',   'N+'},...
                             'required',   {1,            1,      0},...
                             'default',    {'a',          1,      1'}...
                            ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      out = d;
      return
   end
end
try
   [img,h,connectivity] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = -hmaxima(-img,h,connectivity);
