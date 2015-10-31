%VFC   Computes an external force using Vector Field Convolution
%
% SYNOPSIS:
%  f = vfc(edge_image,fsize,gamma)
%
% PARAMETERS:
%  edge_image : scalar image that has large values at the locations
%               you want the snake to end up ( e.g.: gradmag(a) )
%  fsize :      size, in pixels, of the square support of the
%               convolution filter
%  gamma :      kernel parameter
%
% DEFAULTS:
%  fsize = 41
%  gamma = 2
%
% EXAMPLE:
%  a = noise(50+100*gaussf(rr>85,2),'gaussian',20)
%  f = vfc(gradmag(a,5),81);
%  x = 120+50*cos(0:0.1:2*pi); y = 140+60*sin(0:0.1:2*pi);
%  s = [x',y'];
%  snakedraw(s);
%  s = snakeminimize(s,f,0.2,0.4,1,0,60);
%  snakedraw(s);
%
% LITERATURE:
%  B. Li, S.T. Acton, "Active Contour External Force Using Vector Field
%     Convolution for Image Segmentation", IEEE-TIP 16(8):2096-2106 (2007)
%
% SEE ALSO: snakeminimize, gvf, dip_image/gradient

% (C) Copyright 2009, All rights reserved.
% Cris Luengo, Uppsala, 21 September 2009.

function out = vfc(varargin)

d = struct('menu','Segmentation',...
           'display','Vector Field Convolution',...
           'inparams',struct('name',       {'edge_image',     'fsize',      'gamma'},...
                             'description',{'Input image',    'Kernel size','Kernel parameter'},...
                             'type',       {'image',          'array',      'array'},...
                             'dim_check',  {2,                1,            0},...
                             'range_check',{{'real','scalar'},'N+',         'R+'},...
                             'required',   {1,                0,            0},...
                             'default',    {'a',              41,           2}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output force image'},...
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
   [edge_image,fsize,gamma] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

K = newimar(xx(fsize),yy(fsize));
rr = max(norm(K),1e-10);
K = -K./(rr^(gamma+1));

out = newimar(convolve(edge_image,K{1}),convolve(edge_image,K{2}));
out = out./max(norm(out),1e-10);
