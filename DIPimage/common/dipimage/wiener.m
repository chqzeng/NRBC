%WIENER  Wiener filter/restoration
% W(w) = H/(H*H+K), where H = ft(psf)
% K is either given as a fration of max(H*H) or
% by Snn/Sff if K<0 is specified
%
% SYNOPSIS:
%  image_out = wiener(image_in, psf, K, Snn, Sff)
%
% PARMETERS:
%  psf:     Point Spread function
%  K:       Regularization (used instead of Snn and Sff)
%  Snn:     Noise power spectrum, used if K<0
%  Sff:     Signal power spectrum, used if K<0
%
% DEFAULTS:
%  K:      1e-4
%  Sff:    ft(autocorrelation(image_in))
%
% SEE ALSO:
%  tikhonovmiller, mappg

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger Oct 2007

function out = wiener(varargin)

d = struct('menu','Restoration',...
           'display','Wiener filter',...
           'inparams',struct('name',       {'in','psf','K','Snn','Sff'},...
          'description',{'3D image','PSF','Regularization', 'Noise power spectrum','Object power spectrum'},...
          'type',       {'image','image','array','image','image'},...
          'dim_check',  {0,0,0,0,0},...
          'range_check',{[],[],'R',[],[]},...
          'required',   {1,1,0,0,0},...
          'default',    {'in','psf',1e-4,'[]','[]'}...
         ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Restorated image'},...
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
   [in,psf,K,Snn,Sff] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if K >0 & (nargin < 5 | isempty(Sff))
   Sff = ft(autocorrelation(in));
end

H = ft(psf);
if K>0
   K = K * max(abs(H*conj(H)));
else
   if isempty(Snn)
      error('Must specify noise power spectrum.');
   end
   K = Snn/Sff;
end
w = conj(H)/(H*conj(H)+K);
out = real(ift(w*ft(in)));


