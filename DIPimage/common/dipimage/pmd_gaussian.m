%PMD_GAUSSIAN   Perona Malik diffusion with Gaussian derivatives
%
% This function works like PMD, but uses Gaussian derivatives instead.
%
% SYNOPSIS:
%  outimage = pmd_gaussian(in, iterations, K, lambda, sigma)
%
% PARAMETERS:
%  in = image with equal sampling rates in all dimensions
%  K = edge-stopping parameter (4% of the image's range is a good start)
%  lambda = diffusion step (<1, smaller + more iterations = more accurate)
%  sigma = parameter for Gaussian derivatives
%
% DEFAULTS:
%  iterations = 5
%  K = 10
%  lambda = 0.25
%  sigma = 0.8
%
% SEE ALSO: pmd

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2008, Centre for Image Analysis, Uppsala, Sweden.

function out = pmd_gaussian(varargin)

d = struct('menu','Diffusion',...
	'display','Perona-Malik diffusion (Gaussian derivatives)',...
	'inparams',struct('name',       {'in',         'iterations','K',    'lambda','sigma'},...
                     'description',{'Input image','Iterations','K',    'Lambda','Sigma'},...
                     'type', 		  {'image',      'array',     'array','array', 'array'},...
                     'dim_check',  {0,            0,           0,      1,       1},...
                     'range_check',{[],           'R+',        'R+',   'R+',    'R+'},...
                     'required',	  {1,            0,           0,      0,       0},...
                     'default', 	  {'a',          5,           10,     0.25,    0.8}...
                    ),...
   'outparams',struct('name',       {'out'},...
   	                'description',{'Output'},...
   	                'type',       {'image'}...
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
   [in,iterations,K,lambda,sigma] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

% SIMPLE = 1 : Simple implementation using dip_image's vector algebra
% SIMPLE = 0 : Using Gaussian derivative only in the derivative direction (1D convolutions)
% GAUSSIAN = 1 : Using Gaussian derivatives
% GAUSSIAN = 0 : Using finite difference derivatives

SIMPLE = 1;
GAUSSIAN = 1;

if SIMPLE
   % Simple implementation using dip_image's vector algebra
   out = in;
   for ii=1:iterations
      nabla_out = gradientvector(out,sigma);
      out = out + divergence(exp(-(norm(nabla_out)/K)^2)*nabla_out);
   end
else
   % Using Gaussian derivative only in the derivative direction (1D convolutions)
   out = in;
   sz = size(in);
   nd = length(sz);
   for ii=1:iterations
      %nabla_out = gradientvector(out,sigma);
      nabla_out = dip_image('array',[nd,1]);
      for jj=1:nd
         parOrder = zeros(1,nd);
         parOrder(jj) = 1;
         if GAUSSIAN
            nabla_out{jj} = derivative(out,sigma,parOrder,'fir');
         else
            nabla_out{jj} = derivative(out,0,parOrder,'finitediff');
         end
      end
      % D = g(|nabla_out|)
      D = exp(-(norm(nabla_out)/K)^2);
      % Divergence ( D nabla_out )
      for jj=1:nd
         parOrder = zeros(1,nd);
         parOrder(jj) = 1;
         if GAUSSIAN
            out = out + derivative(D*nabla_out{jj},sigma,parOrder,'fir');
         else
            out = out + derivative(D*nabla_out{jj},0,parOrder,'finitediff');
         end
      end
   end
end
