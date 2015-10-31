%MCD   Mean curvature diffusion
%
% SYNOPSIS:
%  function out = mcd(in, sigma, nIterations)
%
% PARAMETERS:
%  in = 2D image with equal sampling rates in both dimensions
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
% SEE ALSO: aniso, ced, cpf, pmd

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham (Dec 2003) - Ported from C code by Robert R. Estes Jr.
% http://msp.cipic.ucdavis.edu/~estes/ftp/diffusion/src/cpf.c

function out = mcd(varargin)

d = struct('menu','Diffusion',...
	'display','Mean curvature diffusion',...
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
%function out = mcd(in, sigma, nIterations)
%if nargin<2 sigma = 1; end    % use noiseSTD to estimate noise level
%if nargin<3 nIterations = 10; end

% there is no modification of rate A here, as proposed by section 4.2 of the paper
% this is true diffusion in the sense that coeffs for next iteration is calc
% from last iteration (i.e. different @ every step)
A = 1;

out = in;
for ii=1:nIterations
   % original C code used Sobel derivatives
   Ix = dx(out,sigma);  Iy = dy(out,sigma);

   % CPF computes a more complicated diffusion coefficient
   % that gives a better corner preservation result
   coefficientData = 1/(8*sqrt(1+(Ix*Ix + Iy*Iy)/(A*A)));

   % Compute the next iteration.  The filter is obtained by taking the
   % eight neighbors of each pixel weighted by the corresponding
   % coefficients above, and then adding 1-their sum times the center
   % pixel. Using 3x3 neighborhood here is better than Gaussian
   coefficientSum = dip_image(conv2([1 1 1], [1 1 1], double(coefficientData), 'same'))...
         - coefficientData;
   out = dip_image(conv2([1 1 1], [1 1 1], double(coefficientData*out), 'same'))...
         - coefficientData*out + (1-coefficientSum)*out;
end
