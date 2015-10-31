%ANISO   Robust anisotropic diffusion using Tukey error norm
%
% SYNOPSIS:
%  out = aniso(in,sigma,iterations,lambda)
%
% PARAMETERS:
%   input = input image
%   sigma = scale parameter on the psiFunction.  Choose this
%      number to be bigger than the noise but small than the real
%      discontinuties. Similar to tonalSigma in bilateral filtering
%   iterations = number of iterations
%   lambda = rate parameter. To approximage a continuous-time PDE,
%      make lambda small and increase the number of iterations.
%
% DEFAULTS:
%  sigma = 20
%  iterations = 10
%  lambda = 0.25
%
% EXAMPLE:
%  Edge stopping effect: view imaginary part of ans with log stretch
%  you would see the kernel evolution of initial pixels in a, they diffuse
%  but stop @ edge.
%  a = readim
%  mask = mod(xx,10)==0 & mod(yy,10)==0
%  aniso(a+mask*i)
%
% LITERATURE:
%  Black et al., "Robust Anisotropic Diffusion", IEEE TIP 7:421-432, 1998.
%
% SEE ALSO: ced, cpf, mcd, pmd

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, August 2002
% November 2003, ported to DIPimage (TP)
% 9 April 2007,  Using FEVAL instead of EVAL. (CL)

function out = aniso(varargin)

d = struct('menu','Diffusion',...
	'display','Robust anisotropic diffusion',...
	'inparams',struct('name',{'in','sigma','iterations','lambda'},...
   'description',{'Input image','Tonal sigma','Iterations','lambda'},...
   'type', 		{'image','array','array','array'},...
   'dim_check',  {0,0,0,0},...
   'range_check',{[],'R+','R+','R+'},...
   'required',	{1,0,0,0},...
   'default', 	{'a',20,10,0.25}...
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
   [in,sigma,iterations,lambda] = getparams(d,varargin{:});
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

%function result = aniso(input,psiFunction,sigma,iterations,lambda)
%if ~exist('psiFunction','var')
%   psiFunction = 'tukeyPsi';
%end
%if ~exist('sigma','var')
%   sigma = 20;
%end
%if ~exist('iterations','var')
%   iterations = 10;
%end
%if ~exist('lambda','var')
%   lambda = 0.25;
%end
%lambda = lambda/4;      % ?????

% Initialize result
out = in;

% Indices for the center pixel and the 4 nearest neighbors
% (north, south, east, west)
[m,n] = size(in);
rowC = [0:m-1];         rowN = [0 0:m-2];    rowS = [1:m-1 m-1];
colC = [0:n-1];         colE = [0 0:n-2];    colW = [1:n-1 n-1];

psiFunction = 'tukeyPsi';     % the robust error norm

for i = 1:iterations
   % Compute difference between center pixel and each of the 4
   % nearest neighbors.
   north = out(rowN,colC)-out(rowC,colC);
   south = out(rowS,colC)-out(rowC,colC);
   east = out(rowC,colE)-out(rowC,colC);
   west = out(rowC,colW)-out(rowC,colC);
   % Evaluate the psiFunction for each of the neighbor
   % differences and add them together.  If the local gradient is
   % small, then the psiFunction should increase roughly linearly
   % with the neighbor difference.  If the local gradient is large
   % then the psiFunction should be zero (or close to zero) so
   % that large gradients are ignored/treated as outliers/stop the
   % diffusion.
   psi = feval(psiFunction,north,sigma) + ...
         feval(psiFunction,south,sigma) + ...
         feval(psiFunction,east,sigma) + ...
         feval(psiFunction,west,sigma);
   % Update result
   out = out + lambda * psi;
end;
return


function y = linearPsi(x,sigma)
y = 2*x;
return;


function y = lorentzianPsi(x,sigma)
y = (2*x)./(2*sigma^2 + abs(x).^2);
return

% modify to work with complex input, do not affect real input
function y = tukeyPsi(x,sigma)
y = newim(x); %changed zeros to dip_image (BR)
id = (real(x) > -sigma) & (real(x) < sigma);
xid = x(id);
y(id) = xid.*((1-(real(xid)/sigma).^2).^2);
return

% original tukeyPsi function that do not suit complex input
%function y = tukeyPsi(x,sigma)
%y = zeros(size(x));
%id = (x > -sigma) & (x < sigma);
%xid = x(id);
%y(id) = xid.*((1-(xid/sigma).^2).^2);
%return

