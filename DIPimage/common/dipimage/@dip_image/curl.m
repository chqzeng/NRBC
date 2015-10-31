%CURL  Calculates the rotation of a 2D/3D vector image.
%
% image_out = curl(image_in, sigma)
%
% PARAMETER:
%  image_in: must be a vector image 
%
% DEFAULT:
%  sigma = 1

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, May 2001
% 10 October 2007: Making better use of DX and DY functions. (CL)

function out = curl(in,sigma)

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

dim = length(in); % vector dimensions
sigma = sigma(:)';
if length(sigma)<dim
   sigma(end+1:dim) = sigma(end);
elseif length(sigma)>dim
   sigma = sigma(1:dim);
end

switch dim
	case 2
      %fprintf('case 2D\n');
      if ndims(in(1)) == 3
         sigma(3) = 0; % this dimension will not be processed at all.
         warning('Assuming input 2D time series: only processing the image dimensions.');
      elseif ndims(in(1)) ~= 2
         error('Unexpected image dimensionality');
	   end
		out = dx(in(2),sigma)-dy(in(1),sigma);
   case 3
		%fprintf('case 3D\n');
      if ndims(in(1)) == 3
		   out = dip_image('array',[3 1]);
		   out(1) = dy(in(3),sigma)-dz(in(2),sigma);
		   out(2) = dz(in(1),sigma)-dx(in(3),sigma);
		   out(3) = dx(in(2),sigma)-dy(in(1),sigma);
      else
         error('Unexpected image dimensionality');
      end
	otherwise
		error('Curl only for 2D/3D vectors.')	
end
