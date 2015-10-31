%NOISE   Add noise to an image
%
% SYNOPSIS:
%  image_out = noise(image_in, noise_type, parameter1, parameter2)
%
% PARAMETERS:
%  noise_type: 'gaussian', 'uniform', 'poisson', 'binary',
%              'saltpepper', 'pink'.
%  The parameters vary for the differnt noise types:
%    Gaussian:
%      parameter1 = standard deviation of the noise
%    Uniform:
%      parameter1 = lower bound
%      parameter2 = upper bound
%    Poisson:
%      parameter1 = conversion
%        The intensity of the input image divided by the conversion
%        variable is used as mean value for the Poisson distribution.
%        The conversion factor can be used to relate the pixel values
%        with the number of counts. For example, to simulate a photon
%        limited image acquired by a CCD camera, the conversion factor
%        specifies the relation between the number of photons recorded
%        and the pixel value it is represented by.
%    Binary:
%      parameter1 = probability for a 1->0 transition
%      parameter2 = probability for a 0->1 transition
%       Image_in must be binary.
%    Salt & pepper:
%      parameter1 = probability for a pixel to become 255
%      parameter2 = probability for a pixel to become 0
%    Brownian:
%      parameter1 = standard deviation of the noise
%        The power spectrum of the noise is 1/f^2.
%    Pink:
%      parameter1 = standard deviation of the noise
%      parameter2 = 1 for pink noise, 2 for Brownian noise.
%        The power spectrum of the noise is 1/(f^parameter2).
%        If parameter2<=0, it is taken as 1, so that the default
%        value creates pink noise. 
%    Blue:
%      parameter1 = standard deviation of the noise
%      parameter2 = 1 for blue noise, 2 for violet noise.
%        The power spectrum of the noise is f^parameter2.
%        If parameter2<=0, it is taken as 1, so that the default
%        value creates blue noise. 
%    Violet:
%      parameter1 = standard deviation of the noise
%        The power spectrum of the noise is f^2.
%
% DEFAULTS:
%  noise_type = 'gaussian'
%  parameter1  = 1
%  parameter2  = 0

% (C) Copyright 1999-2012               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2001.
% 16 October 2008:   Added 'saltpepper' (CL).
% 22 October 2010:   Added 'pink' and 'Brownian' (CL).
% 21 June 2012:      Fixed behaviour with default parameters of 'uniform' (CL).
% 19 September 2012: Added 'blue' and 'violet' (CL).

function out = noise(varargin)

noisetypes = {'gaussian','uniform','poisson','binary','saltpepper','brownian','pink','blue','violet'};
d = struct('menu','Generation',...
           'display','Add noise',...
           'inparams',struct('name',       {'in',         'method',    'par1',      'par2'},...
                             'description',{'Input image','Noise Type','Parameter 1','Parameter 2'},...
                             'type',       {'image',      'option',    'array',     'array'},...
                             'dim_check',  {0,            0,           0,           0},...
                             'range_check',{[],           noisetypes,  'R',         'R'},...
                             'required',   {1,            0,           0,           0},...
                             'default',    {'a',          'gaussian',  1,           0}...
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
   [in,method,par1,par2] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

switch method
   case 'gaussian'
      out = dip_gaussiannoise(in,par1*par1); % for unknown reason DIPlib chose here variance
   case 'uniform'
      if  par1>par2
         [par1,par2] = deal(par2,par1);
      elseif par1==par2
         error('Upper and lower limits are inconsistent.');
      end
      out = dip_uniformnoise(in,par1,par2);
   case 'poisson'
      if  par1<=0
         error('Conversion greater than zero.');
      end
      out = dip_poissonnoise(in,par1);
   case 'binary'
      if par1>1 | par2 >1 | par1<0 | par2<0
         error('Transition probability should be between 0 and 1.');
      end
      out = dip_binarynoise(in,par1,par2);
   case 'saltpepper'
      n = dip_uniformnoise(newim(in), 0, 1);
      out = in;
      out(n>(1-par1)) = 255;
      out(n<par2) = 0;
   case {'brownian','pink'}
      if strcmp(method,'brownian')
         par2 = 2;
      end
      if par2<=0
         par2 = 1;
      end
      tmp = rr(in,'freq','squared')^(-par2/4);  % using 'squared' to avoid computations.
      ind = num2cell(floor(imsize(tmp)/2));
      tmp(ind{:}) = 0;                          % set mean intensity to 0.
      tmp = tmp*(2*par1/sqrt(2*mean(tmp^2)));   % normalize power.
      out = dip_uniformnoise(newim(in),0,2*pi);
      out = in + real(ift(tmp*exp(i*out)));
   case {'blue','violet'}
      if strcmp(method,'violet')
         par2 = 2;
      end
      if par2<=0
         par2 = 1;
      end
      tmp = rr(in,'freq','squared')^(par2/4);   % using 'squared' to avoid computations.
      ind = num2cell(floor(imsize(tmp)/2));
      tmp(ind{:}) = 0;                          % set mean intensity to 0.
      tmp = tmp*(2*par1/sqrt(2*mean(tmp^2)));   % normalize power.
      out = dip_uniformnoise(newim(in),0,2*pi);
      out = in + real(ift(tmp*exp(i*out)));
   otherwise
      error('Unkown noise type.')
end
