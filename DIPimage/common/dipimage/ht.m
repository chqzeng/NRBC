%HT   Hilbert transform for nD images
%  The mean of the image is removed if the mean is greater
%  than 1. The magniutde of the Hilbert Transform is returned.
%
%  SYNOPSIS:
%    [mag_ht, in_mean] = ht(image_in, sigma)
%
%  PARAMETERS:
%    image_in = interference pattern (fringes)
%    sigma    = sigma to remove the local mean
%
%  DEFAULTS:
%    sigma = 10
%
%
% LITERATURE:
% nD case: M. Felsberg, G. Sommer,
%    The Monogenic Signal,
%    IEEE Transactions on Signal Processing, 49(12), pp.3136-3144, 2001
%
% 2D case:  K.G. Larkin, D.J. Bone, M.A. Oldfield,
%    Natural demodulation of two-dimensional fringe patterns.
%     I. General background of the spiral phase quadrature transform
%    J. Opt. Soc. Am. A/Vol. 18, No. 8, pp. 1862-1870/2001.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Jan 2002.
% 28 September 2010: Avoiding use of EVAL. (CL)

function [out, mean_in] = ht(varargin)

d = struct('menu','Transforms',...
  'display','Hilbert transform',...
  'inparams',struct('name',{'in','sigma'},...
        'description',{'Input image','Sigma of Gaussian'},...
        'type',       {'image','array'},...
        'dim_check',  {0,0},...
        'range_check',{'scalar','R+'},...
        'required',   {1,0},...
        'default',    {'a',5}...
       ),...
  'outparams',struct('name',{'out','mean_in'},...
         'description',{'Magnitude HT','Input - local mean'},...
         'type',       {'image','image'}...
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

% remove DC
m = mean(in);
if m > 1 | m <0
   mean_in = in - gaussf(in, sigma);
else
    mean_in = in;
end

%multiplication with \frac{\vec u}{|u|} in Fourier domain

sz = size(in);
y = newim(in);
fb = ft(mean_in);
for ii=1:ndims(in)
   s = sub2ind(fb,floor(sz/2));
   x = rr(sz);
   x(s) = 1;                % avoid division by 0.
   x = fb.*ramp(sz,ii)./x;
   x(s) = fb(s);
   x = ift(x);
   y = y + real(x*conj(x));
end
out = y + mean_in^2;


%suitable test images in 2/3D

%a=1*(rr>100)-1*(rr>99)+1*(rr>80)-1*(rr>60)+1*(rr>59)-1*(rr>40);
%aa=a-gaussf(a,5)

%sz=[128 128 128];
%t=rr(sz);
%b=1*(t>60)-1*(t>59)+1*(t>40)-1*(t>30)+1*(t>29)-1*(t>15)
%bb=b-gaussf(b,3);
