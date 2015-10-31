%RELABEL   Renumber labels in a labeled image
%
% SYNOPSIS:
%  image_out = relabel(image_in)
%
%  image_out will be like image_in, but all label IDs will be
%  consecutive.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2006.
% 15 August 2007: Not calling LUT if labels don't need renumbering.
%                 Fixed bug if there's no background pixels.
% 2 July 2010:    Fixed to pass a numeric array to LUT (apparently nobody
%                 used this function since September 2007!)

function lab = relabel(varargin)

d = struct('menu','Segmentation',...
           'display','Renumber labels',...
           'inparams',struct('name',       {'image_in'},...
                             'description',{'Input image'},...
                             'type',       {'image'},...
                             'dim_check',  {0},...
                             'range_check',{[]},...
                             'required',   {1},...
                             'default',    {'a'}...
                              ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      lab = d;
      return
   end
end
try
   [lab] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

L = unique(dip_array(lab)); % all the used label IDs
if any(mod(L,1)) | any(L<0) % labels should be positive integers
   error('Input image is not a labeled image (all pixels should be positive integers)')
end
if L(1)==0,L(1)=[];end      % remove the background label 0.
if L(end)~=length(L)        % only do anything if the labels IDs aren't continuous.
   N = 1:max(L);            % new array for label IDs.
   N(L) = 1:length(L);      % new label IDs.
   N = dip_array(dip_image([0,N],datatype(lab))); % going through dip_image for easy convering data types
   lab = lut(lab,N);        % do the look-up thing.
end
