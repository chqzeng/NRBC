%GRADIENTVECTOR   Gradient vector
%
% SYNOPSIS:
%  image_out = gradientvector(image_in,sigma)
%
%  IMAGE_IN is a real-valued, scalar image with N dimensions.
%  IMAGE_OUT is a N-by-1 tensor image, where each image component
%  is the Gaussian derivative along one dimensions. That is, each
%  pixel contains the gradient vector of the image at that point.
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
% Bernd Rieger, August 2000.
% Cris Luengo, 21 September 2000: SIGMA is now allowed to be any size vector.

function out = gradientvector(varargin)

d = struct('menu','Differential Filters',...
           'display','Gradient vector',...
           'inparams',struct('name',       {'in',         'sigma'},...
                             'description',{'Input image','Sigma of Gaussian'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {0,            1},...
                             'range_check',{[],           'R+'},...
                             'required',   {1,            0},...
                             'default',    {'a',          1}...
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
try
   [in,sigma] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ~isreal(in)
   error('Input image must be real.')
end

dim = ndims(in);
out = dip_image('array',[dim,1]);
for ii = 1:dim
   parOrder = zeros(dim,1);
   parOrder(ii) = 1;
   out{ii} = derivative(in,sigma,parOrder);
end
