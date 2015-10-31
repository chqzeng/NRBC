%TRANSFORM   Rotate, translate and scale a 2D image
%
% SYNOPSIS:
%  [image_out, org] = transform(image_in, zoom, translation, angle)
% 
% PARAMETERS:
%  zoom        = zoom (one parameter)
%  translation = array containing a transloation
%  angle       = rotation angle [in rad]
%  
%  Interpolation is '3-cubic'.
%
% SEE ALSO: rotation, rotate, resample, rotation3d, find_affine_trans, fmmatch

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2009

function [im2, im1] = transform (varargin)

if nargin == 1 & ischar(varargin{1}) & strcmp(varargin{1},'DIP_GetParamList') % Avoid being in menu
      im2 = struct('menu','none');
      return
end

d = struct('menu','Manipulation',...
           'display','2D transform',...
           'inparams',struct('name',       {'in', 'zoom','translation','ang'},...
                             'description',{'Input image','Zoom','Translation','Rotation'},...
                             'type',       {'image','array','array','array'},...
                             'dim_check',  {0,1,1,0},...           
                             'range_check',{[],'R+','R','R'},...
                             'required',   {1, 0,0,0},...                            
                             'default',    {'a', 1,[0 0],0}...
                              ),...
           'outparams',struct('name',{'im2','im1'},...
                              'description',{'Transformed image','Cut original image'},...
                              'type',{'image','image'}...
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
   [in, zoom, translation, ang ] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)~=2
   error('Input image not 2D.');
end


interpolation_method = '3-cubic';
%interpolation_method = 'linear';
translation = translation.*zoom;
%Transform a dip_image by scaling, rotation, and translation.

im1 = in;
im2 = in;

%Scale second image.
if(zoom ~= 1)
  im2 = resample2(im2, zoom, interpolation_method );
end

%Rotate second image.
if(ang~= 0)
  im2 = rotation(im2, ang, 3, interpolation_method , 'zero');
end

%Translate second image.
Tx = translation(1) * cos(ang) - translation(2) * sin(ang);
Ty = translation(1) * sin(ang) + translation(2) * cos(ang);
im2 = resample(im2, 1, [Tx,Ty], interpolation_method );

%Mask parts outside the image.
masker = newim(size(im2));
Xmin = ceil(max(0,Tx));
Xmax = floor(min(size(im2,1)-1,size(im2,1)+Tx-1));
Ymin = ceil(max(0,Ty));
Ymax = floor(min(size(im2,2)-1,size(im2,2)+Ty-1));
masker(Xmin:Xmax,Ymin:Ymax) = 1;
im2 = im2 * masker;

%Crop largest image to size of the smallest
%newsize = min(min(size(im1)),min(size(im2)));
%newsize=[newsize newsize];
%im1 = cut2(im1,newsize);
%im2 = cut2(im2,newsize);

newsize =  min(cat(1,imsize(im1),imsize(im2)),[],1)
im2 = im1;
im1 = cut2(im1,newsize);


%-------------- Helper functions -----------------------
function im_out = cut2(im_in,newsize)
%Crops the image to a smaller size. Interpolates if sizes are not both even
%or both odd. 
if (size(im_in,1)==size(im_in,2))   %im_in is square
  s_in = size(im_in,1);
  s_out = newsize(1);
  if (mod(s_in,2)==0)    %s_in is even
      if (mod(s_out,2)==0)    %s_out is even
          im_out = cut(im_in,newsize);
      else    %s_out is odd
          im_out = resample2(im_in,4,'3-cubic');    %stretch x4
          im_out = cut(im_out,4.*newsize);               %cut out center
          im_out = resample2(im_out,0.25,'3-cubic'); %stretch x0.25
      end
  else    %s_in is odd
      if (mod(s_out,2)==0)    %s_out is even
          im_out = resample2(im_in,4,'3-cubic');    %stretch x4
          im_out = cut(im_out,4.*newsize);               %cut out center
          im_out = resample2(im_out,0.25,'3-cubic'); %stretch x0.25

      else    %s_out is odd
          im_out = cut(im_in,newsize);
      end
  end
else %im_in is not square
  im_out = resample2(im_in,4,'3-cubic');    %stretch x4
  im_out = cut(im_out,4.*newsize);               %cut out center
  im_out = resample2(im_out,0.25,'3-cubic'); %stretch x0.25
end

function image_out = resample2(image_in, zoom, interpolation_method)
%This function stretches a dipimage with respect to the origin, instead of
%the top left corner (like resample.m does). This function is not (yet)
%designed to handle translations as well. 

%Compute shift caused by cutting off bottom and right edges when resampling to a non-integer amount of pixels:
epsilon1 = (zoom*size(image_in,1)-floor(zoom*size(image_in,1)))/(2*zoom);

%Compute shift caused by resampling with respect to the top left corner instead of the center:
epsilon2 = (1-zoom)/(2*zoom);

%Determine total shift:
delta = epsilon1 + epsilon2;
delta = [delta delta];

%Resample taking the error in shifts in account:
image_out = resample(image_in, zoom, delta, interpolation_method);
