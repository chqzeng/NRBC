%SMOOTH   Smooth all elements of the tensor image.
%
% SYNOPSIS:
%  image_out = smooth(image_in,sigma)
%
% DEFAULTS:
%  sigma = 1
%
% NOTES:
%  The method used to compute the Gaussian filter is chosen through the
%  'DerivativeFlavour' preference (see DIPSETPREF). These are the possible
%  values:
%    - 'gaussfir':   Finite Impulse Resonse filter (convolution with a kernel).
%    - 'gaussiir':   Infinte Impulse Response filter (recursive filtering).
%    - 'gaussft':    Convolution via a multiplication in the Fourier Domain.
%    - 'finitediff': Finite difference filter.
%    - 'best':       Chooses the best option above for your kernel.
%  See DERIVATIVE for an explanation of the option 'best'.
%
%  See the 'Truncation' preference for changing the size of the kernel used
%  by the FIR method.
%
% SEE ALSO:
%  derivative, gaussf, dipsetpref('DerivativeFlavour'), dipsetpref('Truncation')

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, November 2000.
% May, 2003:      Added recursive Gaussian smoothing for large sigmas.
% 9 October 2007: Upgraded from dip_image method to toolbox function,
%                 removed recursive smoothing.
% 30 July 2009:   DERIVATIVE already does ITERATE, no need to do it here also.

function out = smooth(varargin)

d = struct('menu','Filters',...
           'display','Smoothing filter',...
           'inparams',struct('name',       {'image_in',   'sigma'},...
                             'description',{'Input image','Sigma of Gaussian'},...
                             'type',       {'image',      'array'},...
                             'dim_check',  {[],           1},...
                             'range_check',{{'tensor','noncomplex'},'R+'},...
                             'required',   {1,            0},...
                             'default',    {'a',          1}...
                            ),...
           'outparams',struct('name',{'image_out'},...
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
order = zeros(size(sigma));
out = derivative(in,sigma,order);
