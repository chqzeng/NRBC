%NOISESTD   Estimate noise standard deviation
%
% SYNOPSIS:
%  snoise = noisestd(in,mask,frame)
%
% Assumption: White Gaussian noise (since use neighbour differences)
% Limitation: may fail if noise correlated (e.g. result of filtering)
%             and will fail under complex texture.
%
% PARAMETERS:
%  mask = binary regions over which noise is computed ([] means all)
%  frame = the frame over which noise is computed (for 3D input only) 
% 
% EXAMPLE: 
%  a = readim
%  b = noise(a,'gaussian',20)
%  c = hybridf(b)             % better than Lee80
%  d = dip_image(wiener2(double(b),[3 3],noisestd(b)^2))    % Lee80
%  [noisestd(a) noisestd(b) noisestd(c) noisestd(d)] 
%
% LITERATURE:
%  John Immerk�r. "Fast Noise Variance Estimation", 
%  Computer Vision and Image Understanding, Vol. 64, No. 2, p. 300-302, 1996. 
%
% SEE ALSO:
%  mse, mae, mre, lfmse, ssim, psnr.

% (C) Copyright 1999-2012               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.
% March 2012: Rewrite to include in menu. Using DERIVATIVE instead of CONV2.
%             Removed 2nd and 3rd output arguments.

function snoise = noisestd(varargin)

d = struct('menu','Statistics',...
           'display','Estimate standard deviation of noise',...
           'inparams',struct('name',       {'image_in',   'mask',             'frame'},...
                             'description',{'Input image','Mask image',       'frame (3D image only)'},...
                             'type',       {'image',      'image',            'array'},...
                             'dim_check',  {[2,3],        []                  0},...
                             'range_check',{{'scalar','real'},[],             'N'},...
                             'required',   {1,            0,                  0},...
                             'default',    {'a',          '[]',               0}...
                            ),...
           'outparams',struct('name',{'snoise'},...
                              'description',{'Output value'},...
                              'type',{'array'}...
                              )...
          );
if nargin == 1
   s = varargin{1};
   if ischar(s) & strcmp(s,'DIP_GetParamList')
      snoise = d;
      return
   end
end
try
   [in,mask,frame] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if ndims(in)==3
   % could do separable convolution in 3D, but costly & 
   % inaccurate because sampling rate in z direction is not the same
   in = squeeze(in(:,:,frame));
   if ~isempty(mask) & ndims(mask)==3
      mask = squeeze(mask(:,:,frame));
   end
end
   
% avoid estimating noise @ pixels near edges
if isempty(mask)
   mask = ~threshold(gaussf(gradmag(in),3));
else
   if ~isequal(imsize(in),imsize(mask)) | ~strcmp(datatype(mask),'bin')
      error('MASK must be a binary image of same size as IN.');
   end
end

tmp = derivative(in,0,2,'finitediff');

% three methods listed at
% http://www.mip.sdu.dk/~jimm/ipcv/noiseestimation.html
snoise = 1/6 * sqrt(mean(tmp(mask)^2));
% perform poorly in low-noise cases so discard
% s2     = 1/6 * sqrt(pi/2) * mean(abs(tmp(mask)));
% perform so poorly in high-noise cases so discard
% s3     = 1/6 * sqrt(pi/2) * median(abs(tmp(mask)));
