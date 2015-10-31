%GAUSSF   Gaussian filter
%
% SYNOPSIS:
%  image_out = gaussf(image_in,sigma,method)
%
% PARAMETERS:
%  sigma: Gaussian parameter for each dimension
%  method: Method used to compute the Gaussian. One of:
%    - 'fir':  Finite Impulse Resonse filter (convolution with a kernel).
%    - 'iir':  Infinte Impulse Response filter (recursive filtering).
%    - 'ft':   Convolution via a multiplication in the Fourier Domain.
%    - 'best': Chooses the best option above for your kernel.
%
% DEFAULTS:
%  sigma = 1
%  metod (set through the 'DerivativeFlavour' preference, see DIPSETPREF).
%
% NOTES:
%  See DERIVATIVE for an explanation of the option 'best'.
%
%  The 'DerivativeFlavour' preference is translated as follows:
%     - 'gaussfir'    -> 'fir'
%     - 'gaussiir'    -> 'iir'
%     - 'gaussft'     -> 'ft'
%     - anything else -> 'best'
%
%  See the 'Truncation' preference for changing the size of the kernel used
%  by the FIR method.
%
% SEE ALSO:
%  smooth, derivative, dipsetpref('DerivativeFlavour'), dipsetpref('Truncation')

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% added fourier implementation if sigma <1 or DerivativeFlavour is set to fourier (BR)
% 8 November 2006: Calling GAUSS_DERIVATIVE now. (CL)
% 9 October 2007: Added METHOD parameter. (CL)

function image_out = gaussf(varargin)

if nargin==0
   if exist('private/Gauss.jpg','file')
      image_out = dip_image(imread('private/Gauss.jpg'));
      return
   end
end

[defmeth,methlist] = getderivativeflavour('gauss');
d = struct('menu','Filters',...
           'display','Gaussian filter',...
           'inparams',struct('name',       {'image_in',   'sigma',            'method'},...
                             'description',{'Input image','Sigma of Gaussian','Method used for computation'},...
                             'type',       {'image',      'array',            'option'},...
                             'dim_check',  {[],           1                   0},...
                             'range_check',{{'tensor','noncomplex'},'R+',     methlist},...
                             'required',   {1,            0,                  0},...
                             'default',    {'a',          1,                  defmeth}...
                            ),...
           'outparams',struct('name',{'image_out'},...
                              'description',{'Output image'},...
                              'type',{'image'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      image_out = d;
      return
   end
end
try
   [image_in,sigma,method] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

method = getderivativeflavour('alias',method); % will translate back from the Gauss-specific
                                               % strings to the strings for DERIVATIVE.

order = zeros(size(sigma));
image_out = derivative(image_in,sigma,order,method);
