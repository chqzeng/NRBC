%DIVERGENCE  Calculates the divergence of a vector image.
%
% image_out = divergence(image_in, sigma)
%
% PARAMETER:
%  image_in: must be a vector image
%
% DEFAULT:
%  sigma = 1

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, May 2001
% March, 2003, added iterative gaussian filtering for large sigmas
% 10 October 2007: Calling DERIVATIVE instead of DIP_GAUSS directly. (CL)
% 11 October 2011: Removed derivate method selection logic, handled by DERIVATIVE. (CL)

function out = divergence(in,sigma)

if nargin < 2
   sigma = 1;
end
if ~isnumeric(sigma)
   error('Sigma parameter must be numeric.')
   % This assures that IN is a dip_image
end
if ~isvector(in)
   error('Input image not dip_image vector.')
end

vdim = length(in);   %vector dimensions
dim  = ndims(in(1)); %image dimensions per components

process = ones(1,dim);
if vdim < dim
   %time series, no blurring in the z-direction wanted
   warning('Assuming input time series: only processing the image dimensions.');
   process(vdim+1:dim) = 0;
elseif vdim > dim
   error('Why would you have more vector dims that image dims?');
end

sigma = sigma(:)';
if length(sigma)<dim
   sigma(end+1:dim) = sigma(end);
elseif length(sigma)>dim
   sigma = sigma(1:dim);
end
sigma = sigma.*process; % set the sigma for non-processed dimensions to 0.

for ii = 1:vdim
   parOrder = zeros(1,dim);
   parOrder(ii) = 1;
   tmp = derivative(in(ii),sigma,parOrder);
   if ii==1
      out = tmp;
   else
      out = out + tmp;
   end
end
