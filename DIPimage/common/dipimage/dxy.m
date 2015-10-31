%DXY   Second derivative in the XY-direction
%
% SYNOPSIS:
%  image_out = dxy(image_in,sigma)
%
% DEFAULTS:
%  sigma = 1

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% call to gauss_derivative instead to low-level code direclty (BR)

function image_out = dxy(varargin)

d = struct('menu','Differential Filters',...
           'display','Second derivative in XY-direction',...
           'inparams',struct('name',       {'image_in',   'sigma'},...
                             'description',{'Input image','Sigma of Gaussian'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {0,            1},...
                             'range_check',{[],           'R+'},...
                             'required',   {1,            0},...
                             'default',    {'a',          1}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   [image_in,sigma] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
order = zeros(size(sigma));
order(1) = 1;
if length(order)>=2
   order(2) = 1;
end
image_out = derivative(image_in,sigma,order);
