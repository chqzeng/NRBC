%DGG   Second derivative in the gradient-direction
%
% SYNOPSIS:
%  out = dgg(in,sigma)
%
% Computes:
%  g = gradient(in,sigma);
%  h = hessian(in,sigma);
%  out = (g'*h*g) / (g'*g);
%
% DEFAULTS:
%  sigma = 1
%
% SEE ALSO: TFRAMEHESSIAN for reguralised 2nd derivative


% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% April 2002, extended help (BR)
% 10 October 2007: Using same method-selection logic as other derivative functions. (CL)

function out = dgg(varargin)

d = struct('menu','Differential Filters',...
           'display','Dgg (== second derivative in gradient-direction)',...
           'inparams',struct('name',       {'in',   'sigma'},...
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

process = ones(size(sigma));
method = getderivativeflavour('choose',getderivativeflavour,sigma,process); % The order array is the same as the process array.
out = dip_dgg(in,process,sigma,method);
