%OVERLAY   Overlay a grey-value or color image with a binary or label image
%
% SYNOPSIS:
%  image_out = overlay(grey,label,color)
%
% PARAMETERS:
%  label: an image with positive integer values or a binary image.
%  color: the colormap indicating what color each label gets. It is
%         periodically repeated to accomodate indices larger than its
%         length.
%         Type HELP GRAPH3D for a list of default colormaps known to MATLAB.
%
% DEFAULTS:
%  COLOR defaults to the colormap used by the 'labels' mode in DIPSHOW.
%
% SEE ALSO:
%  colormap, lut.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2001.
% March 2006:   Extended to overlay labelled images.
% October 2011: Default binary image overlay color same as for image display.

function out=overlay(grey,lab,colmap)

defcolmap = round(label_colormap(17)*255);
defcolmap(1,:) = [];

% Handle menu call
if nargin == 1
   if ischar(grey) & strcmp(grey,'DIP_GetParamList')
      out = struct('menu','Display',...
                   'display','Overlay image with mask',...
                   'inparams',struct('name',       {'grey',               'lab',           'colmap'},...
                                     'description',{'Grey or color image','Labelled image','Color map'},...
                                     'type',       {'image',              'image',         'array'},...
                                     'dim_check',  {0,                    0,               [-1,3]},...
                                     'range_check',{[],                   [],              [0,255]},...
                                     'required',   {1,                    1,               0},...
                                     'default',    {'a',                  'b',             defcolmap}...
                                    ),...
                   'outparams',struct('name',{'out'},...
                                      'description',{'Output image'},...
                                      'type',{'image'}...
                                     )...
      );
      return
   end
end

% Parse Input
if nargin < 2
   error('Required input missing.')
end
grey = dip_image(grey);
lab = dip_image(lab);
if nargin < 3
   if islogical(lab)
      colmap = 255*dipgetpref('BinaryDisplayColor');
   else
      colmap = defcolmap;
   end
else
   if size(colmap,2) ~= 3
      error('COLORMAP must be of the form [R,G,B].')
   end
end

if ~isequal(size(grey{1}),size(lab))
   error('Sizes do not match.')
end
if isa(grey,'dip_image_array')
   % Input is color image
   if ~istensor(grey)
      error('Input image is an array.')
   end
   out = colorspace(grey,'RGB');
else
   % Input is grey-value image
   out = joinchannels('RGB',grey,grey,grey);
end
if islogical(lab)
   out{1}(lab) = colmap(1,1);
   out{2}(lab) = colmap(1,2);
   out{3}(lab) = colmap(1,3);
else
   if any(lab<0) | any(mod(lab,1))
      error('The LABEL image must contain positive integers only');
   end
   bin = lab>0;
   indx = double(lab(bin));
   indx = mod(indx-1,size(colmap,1))+1;
   out(bin) = {colmap(indx,1),colmap(indx,2),colmap(indx,3)};
end
