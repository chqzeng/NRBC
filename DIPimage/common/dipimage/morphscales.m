%MORPHSCALES   Morphological scale-space
%
% SYNOPSIS:
%  [sp,dp] = morphscales(image_in,filter,base,nscales)
%
% PARAMETERS:
%  filter: The morphological filter used, one of 'closing', 'opening',
%          'dilation' or 'erosion'.
%
% DEFAULTS:
%  filter = 'closing'
%  base = 2
%  nscales = 7

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2000.

function [im_out1,im_out2] = morphscales(varargin)

d = struct('menu','Analysis',...
           'display','Morphological scale-space',...
           'inparams',struct('name',       {'image_in',   'filter', 'scales','base'},...
                             'description',{'Input image','Filter', 'Scales','Base'},...
                             'type',       {'image',      'option', 'array', 'array'},...
                             'dim_check',  {0,            0,        0,       0},...
                             'range_check',{[],           {'closing','opening','dilation','erosion'},'N+',    'R+'},...
                             'required',   {1,            0,        0,       0},...
                             'default',    {'a',          'closing',7,       2}...
                            ),...
           'outparams',struct('name',       {'im_out1','im_out2'},...
                              'description',{'Scale','Difference'},...
                              'type',       {'image','image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      im_out1 = d;
      return
   end
end
try
   [image_in,filter,scales,base] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(image_in) ~= 2
   error('General PB Error.')
end
if base <= 1
   error('Base must be larger than 1.')
end
shape = 'elliptic';
fsize = [base,base];
im_out1 = newim([size(image_in),scales]);
im_out2 = newim([size(image_in),scales-1]);
im_out1(:,:,0) = image_in;
for ii=1:scales-1
   fsize = fsize*base;
   switch filter
      case 'closing'
         im_out1(:,:,ii) = dip_closing(image_in,[],fsize,shape);
         im_out2(:,:,ii-1) = im_out1(:,:,ii)-im_out1(:,:,ii-1);
      case 'opening'
         im_out1(:,:,ii) = dip_opening(image_in,[],fsize,shape);
         im_out2(:,:,ii-1) = im_out1(:,:,ii-1)-im_out1(:,:,ii);
      case 'dilation'
         im_out1(:,:,ii) = dip_dilation(image_in,[],fsize,shape);
         im_out2(:,:,ii-1) = im_out1(:,:,ii-1)-im_out1(:,:,ii);
      case 'erosion'
         im_out1(:,:,ii) = dip_erosion(image_in,[],fsize,shape);
         im_out2(:,:,ii-1) = im_out1(:,:,ii-1)-im_out1(:,:,ii);
      otherwise
         error(['Illegal filter: ',filter,'.'])
   end
end
