%PSNR   Peak Signal-to-Noise Ratio (in dB)
%
% SYNOPSIS:
%  result = psnr(img, org)
%
% PARAMETERS:
%  img: noisy image
%  org: Either one of:
%       - reference image: PSNR from mean squared error (optional)
%       - maximum value:   PSNR from estimated noise & given max
%       - empty:           PSNR from estimated noise & estimated max
%
% SEE ALSO:
%  mse, mae, mre, lfmse, ssim, noisestd.

% (C) Copyright 1999-2012               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.
% 8 March 2012: Reorganized slightly, added to menu.
% 28 June 2012: Computing PSNR through MSE instead of STD, which does
%               something completely different! (CL).

function out = psnr(varargin)

d = struct('menu','Statistics',...
           'display','Peak signal-to-noise ratio',...
           'inparams',struct('name',       {'img',        'org'},...
                             'description',{'Input image','Reference image'},...
                             'type',       {'image',      'image'},...
                             'dim_check',  {[],           []},...
                             'range_check',{{'scalar','real'},{'scalar','real'}},...
                             'required',   {1,            0},...
                             'default',    {'a',          '[]'}...
                            ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Output value'},...
                              'type',{'array'}...
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
   [img,org] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if isempty(org)
   % Estimate (Gaussian) noise and max value from the image
   std_noise = noisestd(img);
   peak_signal = max(img);
else
   if ndims(org)==0 | prod(imsize(org))==1
      % PSNR based on estimated noise and given max value
      std_noise = noisestd(img);
      peak_signal = double(org);
   else
      % PSNR based on the original image
      std_noise = sqrt(mse(img,org));
      peak_signal = max(org);
   end
end

out = 20*log10(peak_signal/std_noise);
