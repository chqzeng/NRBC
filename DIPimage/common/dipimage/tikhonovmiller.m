%TIKHONOVMILLER	Tikhonov Miller restoration
%
% SYNOPSIS:
%  image_out = tikhonovmiller(image_in, psf, reg_para)
%
% PARMETERS:
%  psf:      Point Spread function
%  reg_para: Regularization parameter
%
% DEFAULTS:
%  reg_para: 0, automatical computation
%
% SEE ALSO:
%  wiener, mappg

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bart Vermolen, Bernd Rieger Oct 2007

function out = tikhonovmiller(varargin)

d = struct('menu','Restoration',...
           'display','Tikhonov Miller restoration',...
           'inparams',struct('name',       {'in','psf','reg_para'},...
          'description',{'Input image','PSF', 'Regularization parameter'},...
          'type',       {'image','image','array'},...
          'dim_check',  {0,0,0},...
          'range_check',{[],[],[]},...
          'required',   {1,1,0},...
          'default',    {'in','psf',0}...
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
   [in,psf,reg_para] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if reg_para ==0
   reg_para = find_lambda(in,psf);
end

G = sqrt(prod(size(in))) * ft(in);
H = sqrt(prod(size(psf))) * ft(psf);
FEst = H / (H * H + reg_para) * G;
out = real(ift(FEst)) / sqrt(prod(size(FEst)));
out(out<0) = 0;


