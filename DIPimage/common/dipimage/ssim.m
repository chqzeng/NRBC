%SSIM   Structural similarity index (a visual similarity measure)
%
%  Returns the average SSIM index, for the pixels in <mask>, computed
%  locally in a Gausian window of size <sigma>, using parameters K1
%  and K2. <mask> can be an empty array to process all pixels.
%
% SYNOPSIS:
%  err = ssim(in1,in2,mask,sigma,K1,K2)
%
% PARAMETERS:
%  sigma:  Gaussian parameter for each dimension
%  K1, K2: Small real values between 0 and 1, used to avoid instability
%
% LITERATURE:
%  Z. Wang, A. C. Bovik, H. R. Sheikh, and E. P. Simoncelli, "Image
%  quality assessment: From error measurement to structural similarity,"
%  IEEE Transactions on Image Processing 13(1):600-612, 2004.
%
% SEE ALSO:
%  mse, mae, mre, lfmse, psnr, noisestd.

% (C) Copyright 2011, Cris Luengo, All rights reserved
% Centre for Image Analysis, Uppsala, Sweden
%
% Cris Luengo, July 2011.

function err = ssim(varargin)

d = struct('menu','Statistics',...
           'display','Structural similarity index',...
           'inparams',struct('name',       {'in1',    'in2',    'mask',       'sigma', 'K1',   'K2'},...
                             'description',{'Image 1','Image 2','Mask Image', 'Sigma', 'K1',   'K2'},...
                             'type',       {'image',  'image',  'image',      'array', 'array','array'},...
                             'dim_check',  {0,        0,        0,            1,       0,      0},...
                             'range_check',{[],       [],       [],           'R+',    [0,1],  [0,1]},...
                             'required',   {1,        1,        0,            0,       0,      0},...
                             'default',    {'a',      'b',      '[]',         1.5,     0.01,   0.03}...
                              ),...
           'outparams',struct('name',{'err'},...
                              'description',{'Output value'},...
                              'type',{'array'}...
                              )...
           );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      err = d;
      return
   end
end
try
   [in1,in2,mask,sigma,K1,K2] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ~isempty(mask) & ~islogical(mask)
   error('Mask image must be binary')
end
if K1<=0
   K1 = 1e-6;
end
if K2<=0
   K2 = 1e-6;
end
L = max(max(in1)-min(in1),max(in2)-min(in2));
C1 = (K1*L)^2;
C2 = (K2*L)^2;
m1 = gaussf(in1,sigma);
m2 = gaussf(in2,sigma);
m1m2 = m1*m2;
m1 = m1^2;
m2 = m2^2;
s1 = gaussf(in1^2,sigma)-m1;
s2 = gaussf(in2^2,sigma)-m2;
s12 = gaussf(in1*in2,sigma)-m1m2;
err = ((2*m1m2+C1)*(2*s12+C2))/((m1+m2+C1)*(s1+s2+C2));
err = mean(err,mask);
