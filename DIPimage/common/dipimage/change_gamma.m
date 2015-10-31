%CHANGE_GAMMA   Change the gamma of the input image
%
% SYNOPSIS:
%  image_out = change_gamma(image_in, gammaval, functionstyle, center_point, ...
%              colorspace)
%
% DEFAULTS:
%  gammaval      = 1  (nothing happens)
%  functionstyle = 1
%  center_point  = []
%  colorspace    = colorspace(image_in) (if this is not a correct colorspace,
%                                        'Lab' is used)
%
% DESCRIPTION:
%  In this function the input image is changed with a gamma manipulation.
%
%  There are three different function styles:
%  1.  out = min + (max-min)*((in-min)/(max-min))^gammaval
%  2.  center = (max+min)/2
%         out = min + (center-min) * ((in-min)./(center-min))^gammaval
%              for in < center
%         out = max + (center-max) * ((in-max)./(center-max))^gammaval
%              for in >= center
%  3.  the same as 2, but now with a given center_point. This center_point
%        may differ for the different pixel values.
%
%  There are 5 different colorspaces in which this function can be performed:
%  1.  CIELAB: gamma manipulation of the Lightness L (a and b constant)
%  2.  CIELUV: gamma manipulation of the Lightness L (u and v constant)
%  3.  XYZ/Yxy: gamma manipulation of the luminance Y (x and y constant)
%  4.  RGB: gamma manipulation of R, G and B. Different gamma values can be
%        given for the different planes.
%  5.  GREY: gamma manipulation of the grey value image
%
%  Note that the center_point definition only makes sense for functionstyle 3,
%  otherwise it is ignored.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Judith Dijk, June 2002.
% 20 October 2007: Moved to toolbox directory, serious simplifications. (CL)

function out = change_gamma(in, gamma, functionstyle, meanim, col)
% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   out = struct('menu','none');
   return
end

in = dip_image(in);
if nargin < 2, gamma = 1; end % er veranderd niets
if nargin < 3, functionstyle = 1; end % fprintf(1, 'meanim = %d, functionstyle = %d \n', meanim, functionstyle);
if nargin < 4, meanim = []; end
if nargin < 5, col = colorspace(in); end

if isempty(meanim) & functionstyle == 3
   functionstyle = 2;
end
if functionstyle == 3
   meanim = dip_image(meanim);
   if ~isscalar(meanim) | (prod(imsize(meanim))~=1 & imsize(meanim)~=imsize(in))
      error('CENTER_POINT should be a scalar or a scalar image of the same size as IMAGE_IN.')
   end
   if prod(imsize(meanim))==1
      meanim = double(meanim);
   end
end

switch lower(col)
   case {'lab','cielab','l*a*b*'}
      col = 'L*a*b*';
   case 'rgb'
      col = 'RGB';
   case {'xyz','yxy'}
      col = 'Yxy';
   case 'grey'
      col = 'grey';
   %case {'luv','cieluv','l*u*v*'}
   otherwise
      col = 'L*u*v*';
end
if ~iscolor(in)
   col = 'grey'; % Don't ever do a colorspace conversion if the input is grey.
end

if ~strcmp(col, 'RGB')
   if prod(size(gamma)) ~= 1
      error('gamma can only be one value for this colorspace');
   end
else
   if prod(size(gamma)) ~= 1 & prod(size(gamma)) ~= 3
      error('gamma should have 1 or 3 values.');
   end
end

if strcmp(col,'grey')
   image_L = colorspace(in,'grey');
   out = change_gamma_grey(in, gamma, functionstyle, meanim);
elseif strcmp(col,'RGB')
   out = change_gamma_rgb(in, gamma, functionstyle, meanim);
else
   ori_col = colorspace(in);
   out = colorspace(in, col);
   out{1} = change_gamma_grey(out{1}, gamma, functionstyle, meanim);
   out = colorspace(out, ori_col );
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out] = change_gamma_grey(in, gamma, functionstyle, meanim)

switch ( functionstyle )
   case 1
      maxim = max(in);
      minim = min(in);
      out = minim + (maxim-minim).*((in-minim)./(maxim-minim)).^gamma;
   case 2
      maxim = max(in);
      minim = min(in);
      meanim = (maxim-minim)/2+minim;
      out = pivot_scalar_gamma(in,maxim,minim,meanim,gamma);
   case 3
      maxim = max(in);
      minim = min(in);
      if isnumeric(meanim)
         out = pivot_scalar_gamma(in,maxim,minim,meanim,gamma);
      else
         out = pivot_image_gamma(in,maxim,minim,meanim,gamma);
      end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out] = change_gamma_rgb(in, gamma, functionstyle, meanim)

if prod(size(gamma)) == 1
   gammaR = gamma; gammaG = gamma; gammaB = gamma;
else
   gammaR = gamma(1); gammaG = gamma(2); gammaB = gamma(3);
end

%fprintf(1, 'The conversion colorspace = %s\n', col);
ori_col = colorspace(in);
out = colorspace(in, 'RGB');

out{1}(out{1}<0) = 0;
out{2}(out{2}<0) = 0;
out{3}(out{3}<0) = 0;

switch ( functionstyle )
   case 1
      out{1} = (out{1}./255).^gammaR.*255;
      out{2} = (out{2}./255).^gammaG.*255;
      out{3} = (out{3}./255).^gammaB.*255;
   case 2
      maxim = 255;
      minim = 0;
      meanim = 127.5;
      out{1} = pivot_scalar_gamma(out{1},maxim,minim,meanim,gamma);
      out{2} = pivot_scalar_gamma(out{2},maxim,minim,meanim,gamma);
      out{3} = pivot_scalar_gamma(out{3},maxim,minim,meanim,gamma);
   case 3
      maxim = 255;
      minim = 0;
      if isnumeric(meanim)
         out{1} = pivot_scalar_gamma(out{1},maxim,minim,meanim,gamma);
         out{2} = pivot_scalar_gamma(out{2},maxim,minim,meanim,gamma);
         out{3} = pivot_scalar_gamma(out{3},maxim,minim,meanim,gamma);
      else
         out{1} = pivot_image_gamma(out{1},maxim,minim,meanim,gamma);
         out{2} = pivot_image_gamma(out{2},maxim,minim,meanim,gamma);
         out{3} = pivot_image_gamma(out{3},maxim,minim,meanim,gamma);
      end
end

out = colorspace(out,ori_col);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function in = pivot_scalar_gamma(in,maxim,minim,meanim,gamma)
mask = in >= meanim;
in(mask)  = maxim + (meanim-maxim)*((in(mask)-maxim)/(meanim-maxim)).^gamma;
mask = ~mask;
in(mask) = minim + (meanim-minim)*((in(mask)-minim)/(meanim-minim)).^gamma;

function in = pivot_image_gamma(in,maxim,minim,meanim,gamma)
mask = in >= meanim;
in(mask)  = maxim + (meanim(mask)-maxim)*((in(mask)-maxim)/(meanim(mask)-maxim)).^gamma;
mask = ~mask;
in(mask) = minim + (meanim(mask)-minim)*((in(mask)-minim)/(meanim(mask)-minim)).^gamma;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [out] = change_gamma_L(in, gamma, functionstyle, meanim, col)
% This function not used any more. It does have some checks and clipping that
% were not in the versions above, that I reused to substitute this version,
% so I'm leaving it here for the interested...

ori_col = colorspace(in);
out = colorspace(in, col);
image_L = out{1};

switch ( functionstyle )
   case 1
      maxim = max(image_L);
      minim = min(image_L);
      image_L = minim + (maxim-minim).*((image_L-minim)./(maxim-minim)).^gamma;
   case 2
      maxim = max(image_L);
      minim = min(image_L);
      meanim = (maxim-minim)/2+minim;

      x = (image_L-minim)./(meanim-minim);
      x(x<0) = 0; % x = (x>0)*x + (x<=0)*0;
      image_L_out1 = minim + (meanim-minim).*x.^gamma;
      x = (image_L-maxim)./(meanim-maxim);
      x(x<0) = 0; % x = (x>0)*x + (x<=0)*0;
      image_L_out2 = maxim + (meanim-maxim).*x.^gamma;
      image_L = (image_L_out1).*(image_L < meanim) + (image_L_out2).*(image_L >= meanim);
   case 3
      maxim = max(image_L);
      minim = min(image_L);
      %fprintf(1, 'maxim = %f, minim = %f, meanim = %f\n', maxim, minim, meanim);
      if( meanim < minim )
         meanim = minim;
         fprintf(1, 'The center point is chosen badly.\n');
         fprintf(1, 'The maximum = %f, the minimum = %f.\n', maxim, minim);
         fprintf(1, 'This is a gamma change of functionstyle 1 with gamma = %f\n', 1./gamma);
      end
      if( meanim > maxim )
         meanim = maxim;
         fprintf(1, 'The center point is chosen badly.\n');
         fprintf(1, 'The maximum = %f, the minimum = %f.\n', maxim, minim);
         fprintf(1, 'This is a gamma change of functionstyle 1 with gamma = %f\n', gamma);
      end

      if( meanim ~= minim )
         x = (image_L-minim)./(meanim-minim);
         x = (x>0)*x + (x<=0)*0;
         image_L_out1 = minim + (meanim-minim).*x.^gamma;
      else
         image_L_out1 = image_L.*0;
      end
      if( meanim ~= maxim )
         x = (image_L-maxim)./(meanim-maxim);
         x = (x>0)*x + (x<=0)*0;
         image_L_out2 = maxim + (meanim-maxim).*x.^gamma;
      else
         image_L_out2 = image_L.*0;
      end
      image_L = (image_L_out1).*(image_L < meanim) + (image_L_out2).*(image_L >= meanim);
end

out{1} = image_L;
out = colorspace(out, ori_col );
