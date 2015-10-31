%HESSIAN   Hessian matrix of an image
%   Hessian matrix of a real valued, scalar image. The return type is 
%   an NxN tensor image, where N is the dimensionality of A.
%
%  SYNOPSIS:
%   out = hessian(in, sigma)
%
%  DEFAULTS:
%   sigma = 1;

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, August 2000.
% 21 September 2000: SIGMA1 and SIGMA2 are now allowed to be any size vectors. (CL)
% 27 April 2001:     Do second derivative direct instead of twice first. (BR)
% 10 Jan 2002:       Clean up help information. (BR)
% 9 October 2007:    Calling GAUSS_DERIVATIVE instead of low-level code directly. (CL)

function out = hessian(varargin)

if nargin==0
   if exist('private/Hesse.jpg','file')
      out = dip_image(imread('private/Hesse.jpg'));
      return
   end
end

d = struct('menu','Differential Filters',...
           'display','Hessian matrix',...
           'inparams',struct('name',       {'in',             'sigma'},...
                             'description',{'Input image',    'Sigma of Gaussian'},...
                             'type',       {'image',          'array'},...
                             'dim_check',  {[],               1},...
                             'range_check',{{'scalar','real'},'R+'},...
                             'required',   {1,                0},...
                             'default',    {'a',              1}...
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


dim = ndims(in);
out = dip_image('array',[dim,dim]);

parOrder = zeros(1,dim);
for ii = 1:dim
   for jj = 1:ii %only do half the matrix
      parOrder(:) = 0;
      if ii==jj
         parOrder(ii) = 2; %diagonal elements
      else
         parOrder(ii) = 1; %off-diagonal elements
         parOrder(jj) = 1;
      end
      out{ii,jj} = derivative(in,sigma,parOrder);
      if ii ~= jj
         out{jj,ii} = out{ii,jj}; %use the symmetry
      end
   end
end
