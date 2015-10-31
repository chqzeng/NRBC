%PMD   Perona Malik anisotropic diffusion
%
% SYNOPSIS:
%  outimage = pmd(in, iterations, K, lambda)
%
% PARAMETERS:
%  in = image with equal sampling rates in all dimensions
%  K = edge-stopping parameter (4% of the image's range is a good start)
%  lambda = diffusion step (<1, smaller + more iterations = more accurate)
%
% DEFAULTS:
%  iterations = 5
%  K = 10
%  lambda = 0.25
%
% EXAMPLE:
%  pmd(readim,5,10)
%  pmd(readim('nr077_01'),5,40)
%
% EXAMPLE:
%  Edge stopping effect: view imaginary part of ans with log stretch
%  you would see the kernel evolution of initial pixels in d, they diffuse
%  but stop @ edge. Yet, since the pixels are so close to the edge
%  their diffusion is slow. for pix right on edge as in f, it is clear
%  that diffusion occurs along local orientation, edge still avoided
%  a = readim
%  b = gradmag(a)
%  c = threshold(b)
%  d = xor(bdilation(c),c) & mod(xx,10)==0      % pix close to edge
%  e = xor(bdilation(c,2),bdilation(c,1)) & mod(xx,10)==0   % further from edge
%  f = bskeleton(berosion(c))       % (mostly) single pix on edge
%  pmd(a+d*i,5,10)
%
% LITERATURE:
%  Perona, Shiota and Malik, "Anisotropic Diffusion", in
%   B.M. ter Haar Romeny (Ed.), "Geometry-Driven Diffusion in Computer Vision", 1994
%
% SEE ALSO: aniso, ced, cpf, mcd

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, August 2002
% November 2003, added 3D support (TP)
% 24 October 2008, made nD. (CL)

function out = pmd(varargin)

d = struct('menu','Diffusion',...
	'display','Perona-Malik diffusion',...
	'inparams',struct('name',{'in','iterations','K','lambda'},...
   'description',{'Input image','Iterations','K','lambda'},...
   'type', 		{'image','array','array','array'},...
   'dim_check',  {0,0,0,1},...
   'range_check',{[],'R+','R+','R+'},...
   'required',	{1,0,0,0},...
   'default', 	{'a',5,10,0.25}...
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
   [in,iterations,K,lambda] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = in;
sz = size(in);
nd = length(sz);
for ii=1:iterations
   for jj=1:nd
      delta = dip_convolve1d(out,[0,1,-1],jj-1,[]);
      delta = delta * exp(abs(delta)*(-1/K));            % exp(-|d|/K)      % Tuan's Choice
      %delta = delta * exp(-(abs(delta)*(1/K))^2);       % exp(-(|d|/K)^2)  % common choice
      %delta = delta / (1+(abs(delta)*(1/K))^2);         % 1/(1+(|d|/K)^2)  % also common choice
      delta = dip_convolve1d(delta,[1,-1,0],jj-1,[]);
      out = out + lambda(jj)*delta;
   end
end
