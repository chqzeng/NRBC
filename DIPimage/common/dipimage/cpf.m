%CPF   Nonlinear diffusion using corner preserving formula (improved over MCD)
%
% SYNOPSIS:
%  function out = cpf(in, sigma, nIterations)
%
% PARAMETERS:
%  in = 2D input image
%  sigma = for Gaussian derivative, should increase with noise level
%
% DEFAULTS:
%  sigma = 1
%  nIterations = 10
%
% LITERATURE:
%  A.I. El-Fallah and G.E. Ford, "Mean curvature evolution and
%   surface area scaling in Image Processing" IEEE Trans. IP
%   vol. 6, no. 5, pp. 750-753, 1997
%
% SEE ALSO: aniso, ced, mcd, pmd

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham (Dec 2003) - Ported from C code by Robert R. Estes Jr.
% http://msp.cipic.ucdavis.edu/~estes/ftp/diffusion/src/cpf.c

function out = cpf(varargin)

d = struct('menu','Diffusion',...
	'display','Corner perserving diffusion',...
	'inparams',struct('name',{'in','sigma','iterations'},...
   'description',{'Input image','Derivative sigma','Iterations'},...
   'type', 		{'image','array','array'},...
   'dim_check',  {0,1,0},...
   'range_check',{[],'R+','R+'},...
   'required',	{1,0,0},...
   'default', 	{'a',1,10}...
	),...
   'outparams',struct('name',{'out'},...
   	  'description',{'Output'},...
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
   [in, sigma, nIterations] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)>2
   error('Only supporting <3D images up to now.');
end

% old function declaration & default parameters
%function out = cpf(in, sigma, nIterations)
%if nargin<2 sigma = 1; end    % use noiseSTD to estimate noise level
%if nargin<3 nIterations = 10; end

out = in;
for ii=1:nIterations
   % original C code used Sobel derivatives -> need more iterations
   Ix = dx(out,sigma);  Iy = dy(out,sigma);
   Ixx = dxx(out,sigma);  Ixy = dxy(out,sigma);  Iyy = dyy(out,sigma);

   E = 1 + Ix*Ix;  F = Ix*Iy;  G = 1 + Iy*Iy;

   W = sqrt(E*G - F*F);

   L = Ixx/W;  M = Ixy/W;  N = Iyy/W;

   tmp = (G*L - 2*F*M + E*N)*(W-1)/(W*W);

   % Compute the diffusion coefficient image:
   coefficientData = 1/(8*W*sqrt(1+tmp*tmp));

   % Compute the next iteration.  The filter is obtained by taking the
   % eight neighbors of each pixel weighted by the corresponding
   % coefficients above, and then adding 1-their sum times the center
   % pixel. Using 3x3 neighborhood here is better than Gaussian
   coefficientSum = dip_image(conv2([1 1 1], [1 1 1], double(coefficientData), 'same'))...
         - coefficientData;
   out = dip_image(conv2([1 1 1], [1 1 1], double(coefficientData*out), 'same'))...
         - coefficientData*out + (1-coefficientSum)*out;
end
