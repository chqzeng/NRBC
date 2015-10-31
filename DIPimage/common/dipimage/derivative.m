%DERIVATIVE   Derivative filters
%
% SYNOPSIS:
%  image_out = derivative(image_in,sigma,order,method)
%
% PARAMETERS:
%  sigma:  Gaussian parameter for each dimension
%  order:  Derivative order (order>3 => fourier derivative)
%  method: Method used to compute the derivative. One of:
%    - 'gaussfir':   Finite Impulse Resonse filter (convolution with a kernel).
%    - 'gaussiir':   Infinte Impulse Response filter (recursive filtering).
%    - 'gaussft':    Convolution via a multiplication in the Fourier Domain.
%    - 'finitediff': Finite difference filter.
%    - 'best':       Chooses the best option for your kernel.
%
% DEFAULTS:
%  sigma = 1
%  order = 1
%  metod (set through the 'DerivativeFlavour' preference, see DIPSETPREF).
%
% EXAMPLE:
%  a = readim;
%  derivative(a,1,0)         == gaussf(a,1)
%  derivative(a,[1 1],[1 0]) == dx(a,1)
%  derivative(a,[1 0],[1 0]) == dx(a,[1 0])
%
% NOTES:
%  The "best option for your kernel" means the following:
%   - if any SIGMA is smaller than 0.8, the Fourier method is used,
%   - otherwise, if any SIGMA is larger or equal to 10, the IIR method is used,
%   - otherwise the FIR method is used.
%  The IIR method is fastest for large kernels, whereas the Fourier method is
%  the only one that can produce accurate results for small kernels. If any
%  SIGMA equals 0, this dimension is ignored, and thus does not influence the
%  method chosen.
%
%  The preference above is overridden if:
%   - any ORDER is larger than 3
%   - any SIGMA is 0 and the corresponding ORDER is not
%  In these cases, the Fourier method is always selected over FIR or IIR.
%
%  See the 'Truncation' preference for changing the size of the kernel used
%  by the FIR method.
%
% SEE ALSO:
%  gaussf, dx, dy, etc., dipsetpref('DerivativeFlavour'), dipsetpref('Truncation')

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Lucas van Vliet, May 2000.
% April 2004:  Derivative of higher orders are now computed in the Fourier domain! (KvW)
% August 2004: Derivatives >3 via ft instead >2 (BR)
% June 2006:   Integrated the code from GAUSS_FOURIER into here.
% October 2006: Added possibility to always do Fourier domain implemenation via preference
%               and always do fourier for sigma <1. All dx,dy etc now are only a front-end
%               to this function, which should make any future changes easier (BR).
% November 2006:   Changed behaviour of sigma=0 and order=0 as CL suggested (BR)
% 8 November 2006: Changed behaviour for DerivativeFlavour. (CL)
% 9 October 2007:  Added METHOD parameter, calling DIP_DERIVATIVE. (CL)
% 10 October 2007: Renamed from GAUSS_DERIVATIVE to DERIVATIVE. (CL)
% 11 October 2007: Don't set PROCESS to 0 just because SIGMA==0, but only if ORDER==0 as well. (CL)
% 30 July 2009:    Added %#function pragma. (CL)

function out = derivative(varargin)

[defmeth,methlist] = getderivativeflavour;
d = struct('menu','Differential Filters',...
           'display','General derivatives',...
           'inparams',struct('name',       {'image_in',   'sigma',            'order',           'method'},...
                             'description',{'Input image','Sigma of Gaussian','Derivative Order','Method used for computation'},...
                             'type',       {'image',      'array',            'array',           'option'},...
                             'dim_check',  {[],           1,                  1,                 0},...
                             'range_check',{{'tensor','noncomplex'},'R+',     'N',               methlist},...
                             'required',   {1,            0,                  0,                 0},...
                             'default',    {'a',          1,                  1,                 defmeth}...
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
if nargin>=4
   varargin{4} = getderivativeflavour('alias',varargin{4});
end
try
   [image_in,sigma,order,method] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

method = getderivativeflavour('choose',method,sigma,order);
process = ones(size(sigma));
process(sigma<=0 & order==0) = 0;
%#function dip_derivative
out = iterate('dip_derivative',image_in,process,sigma,order,method);
