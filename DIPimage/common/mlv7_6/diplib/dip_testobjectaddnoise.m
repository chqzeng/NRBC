%dip_testobjectaddnoise   TestObject generation function.
%    out = dip_testobjectaddnoise(object, background, backvalue,...
%          gaussianNoise, poissonNoise, snr)
%
%   object
%      Image.
%   background
%      Image.
%   backvalue
%      Real number.
%   gaussianNoise
%      Real number.
%   poissonNoise
%      Real number.
%   snr
%      Real number.
%
%
% This functions computes:
%
%   % Determine the objects energy and the mean intensity of object and
%   % background. We need these value to determine the variance value to
%   % generate an image with the required SNR.
%   objEnergy = mean(abs(object).^2);
%   objIntensity = mean(abs(object));
%   if ~isempty(background)
%      backIntensity = mean(abs(background));
%   else
%      backIntensity = backvalue;
%   end
%   % Add background
%   if ~isempty(background)
%      out = object + background;
%   else
%      out = object + backvalue;
%   end
%   % normalize amount of Poisson and Gaussian noise
%   pn = poissonNoise / (gaussianNoise + poissonNoise);
%   gn = gaussianNoise / (gaussianNoise + poissonNoise);
%   % Add Poisson Noise
%   if poissonNoise
%      out(out<0) = 0;
%      cnv  = (snr * (backIntensity + objIntensity)) / (objEnergy * pn);
%      out = dip_poissonnoise(out,cnv);
%   end
%   % Add Gaussian Noise
%   if gaussianNoise
%      var  = objEnergy / (snr * gn);
%      out = dip_gaussiannoise(out, var);
%   end

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.
