%RESAMPLE   Resample an image
%
% SYNOPSIS:
%  image_out = resample(image_in, zoom, translation, interpolation_method)
%
% PARAMETERS:
%  zoom        = array containing a zoom [for each dimension]
%  translation = array containing a shift [for each dimension]
%  interpolation_method = 'bspline', '4-cubic', '3-cubic', 'linear', 'zoh', 'nn',
%                         'lanczos2', 'lanczos3', 'lanczos4', 'lanczos6', 'lanczos8'.
%                         For binary images, use 'nn'.
%
% MATHEMATICAL OPERATION:
%  With zoom and translation as vectors, and pos the position vector:
%  image_out(pos)=image_in( (pos+translation)/zoom );
%
% DEFAULTS:
%  zoom        = 2
%  translation = 0
%  interpolation_method = 'lanczos3'
%
% EXAMPLE:
%  a = readim; c = readim('chromo3d');
%  b = resample(a,[.5 1],[-40 0])
%  d = resample(c,[1.2 1 2],[0 30 0])
%
% NOTE:
%  For interpolation methods that do not generate values outside the input
%  range ('linear', 'zoh' and 'nn'), the output data type is the same as
%  that of the input. For other interpolation methods, integer images are
%  cast to single-precision floating point before calling the underlying
%  library function DIP_RESAMPLING. If this behaviour is undesired, please
%  call that function directly.
%
% SEE ALSO:
%  shift, dip_image/circshift, rotation, rotation3d.

% (C) Copyright 1999-2013               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2001.
% ??:            Changed default interpolation to linear
% 14 March 2005: Fixed zoom==0 problem.
% Nov 2007:      Added MATHEMATICAL OPERATION (including warning) section
%                to the help (MvG).
% Jan 2009:      Bug fix in the computation of the pixel size. (BR)
% 7 March 2013:  Casting to float for most interpolation methods.
%                Allowing binary input.
%                'lanczos3' is now the default interpolation method. (CL)

function out = resample(varargin)

d = struct('menu','Manipulation',...
           'display','Resample',...
           'inparams',struct('name',       {'in','zoom','trans','interp'},...
                             'description',{'Input image','Zoom','Translation','Interpolation method'},...
                             'type',       {'image','array','array','option'},...
                             'dim_check',  {0,1,1,0},...
                             'range_check',{[],[realmin,+Inf],'R',{'linear','4-cubic','3-cubic','bspline','zoh','nn','lanczos2','lanczos3','lanczos4','lanczos6','lanczos8'}},...
                             'required',   {1,0,0,0},...
                             'default',    {'a',2,0,'lanczos3'}...
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
if nargin >= 4 & isequal(varargin{4},'bilinear')
   varargin{4} = 'linear';
end
try
   [in,zoom,trans,interp] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ~any(strcmp(interp,{'linear','zoh','nn'}))
   for ii=1:prod(imarsize(in))
      if isinteger(in{ii}) | islogical(in{ii})
         in{ii} = dip_image(in{ii},'sfloat');
      end
   end
end
l = zeros(imarsize(in));
for ii=1:prod(imarsize(in))
   if islogical(in{ii})
      in{ii} = +in{ii};
      l(ii) = 1;
   end
end
%#function dip_resampling
out = iterate('dip_resampling',in,zoom,trans,interp);
out.pixelsize = in.pixelsize./zoom;
if any(l)
   for ii=1:prod(imarsize(in))
      if l(ii)
         out{ii} = dip_image(out{ii},'bin');
      end
   end
end
