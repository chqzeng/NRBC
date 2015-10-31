%DIP_IMAGE_ARRAY   Creates an array of empty dip_images
%   DIP_IMAGE_ARRAY calls NEWIMAR. See NEWIMAR

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2001.

function out = dip_image_array(varargin)
% Avoid being in menu
if nargin == 1 & ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList')
   out = struct('menu','none');
   return
end
% NEWIMAR is the new name for DIP_IMAGE_ARRAY:
out = newimar(varargin{:});
