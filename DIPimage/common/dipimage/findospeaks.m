%FINDOSPEAKS   Find peaks in Orientation Space
%
% SYNOPSIS:
%  [amplitude,orientation] = findospeaks(image_in)
%
% DESCRIPTION
%
%

% (C) Copyright 2000                    Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Michael van Ginkel, October 2000.

function [amplitude,orientation] = findospeaks(varargin)

if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      amplitude = struct('menu','none');;
      return
   end
end
inp = struct('name', {'image_in'},...
              'description',{'Input image'},...
              'type',       {'image'},...
              'dim_check',  {0},...
              'range_check',{[]},...
              'required',   {1},...
              'default',    {'ans'}...
             );

d = struct('menu','Analysis',...
           'display','Find OS peaks',...
           'inparams', inp,...
           'outparams',struct('name',{'amplitude','orientation'},...
                              'description',{'Amplitude','Orientation'},...
                              'type',{'image','image'}...
                              )...
          );
try
   image_in = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ~isreal(image_in)
   error('Input image is not real (use abs).')
end
if ~isempty(find(image_in < 0))
   error('Input image is not positive.')
end
%tmp = dip_simplegaussfitimage(image_in,2,1);
tmp = dip_simplegaussfitimage(image_in,2,1,'parabolic');
amplitude = tmp(:,:,[0 3 6]);
orientation = tmp(:,:,[1 4]);
clear tmp;
