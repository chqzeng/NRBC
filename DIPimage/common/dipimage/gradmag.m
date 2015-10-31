%GRADMAG   Gradient magnitude
%
% SYNOPSIS:
%  image_out = gradmag(image_in,sigma)
%
% DEFAULTS:
%  sigma = 1

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% July 2007, call to gauss_derivative instead to low-level code direclty (BR)
% 10 October 2007: Using same method-selection logic as other derivative functions. (CL)

function image_out = gradmag(varargin)

d = struct('menu','Differential Filters',...
           'display','Gradient magnitude',...
           'inparams',struct('name',       {'image_in',   'sigma'},...
                             'description',{'Input image','Sigma of Gaussian'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {[],           1},...
                             'range_check',{'scalar',     'R+'},...
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

process = ones(size(sigma));
method = getderivativeflavour('choose',getderivativeflavour,sigma,process); % The order array is the same as the process array.
image_out = dip_gradientmagnitude(image_in,process,sigma,method);
