%SHIFT   Shift a nD image
%
% The shift is computed by modifying the phase in the Fourier domain.
%
% SYNOPSIS:
%  image_out = shift(image_in, translation, killNy)
%
% PARAMETERS:
%  translation: 1 x n array containing the shift in the different dimensions.
%  killNy:      set all frequencies beyond the Nyquist frequency to zero in
%               the Fourier domain.
%
% EXAMPLE:
%  a = readim;
%  b = shift(a,[10.5 -4.1]);
%  findshift(a,b,'iter')
%
% SEE ALSO:
%  resample, dip_image/circshift
%
% NOTES:
%     b = shift(a,t);
%  is equivalent to
%     b = real(ift( ft(a) * exp(-i*xx(a,'radfreq')*t) ));
%  for a 1D image 'a'. For each additional dimension, an extra phase term
%  is computed: exp(-i*yy), exp(-i*zz), ...
%
%  By default all frequencies beyond the Nyquist frequency (>=pi) are set
%  to zero in the Fourier domain before back transformation. Information
%  there cannot be obtained from proper sampling.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, March 2001.
% Sep 2006, added option to not zero out >Nyquist frequency in Fourier domain.
% 29 Oct 2009, improved help. (BR,CL)

function image_out = shift(varargin)

d = struct('menu','Manipulation',...
           'display','Shift',...
           'inparams',struct('name',       {'image_in',   'trans', 'killNy'},...
                             'description',{'Input image','Translation','Remove frequencies > Nyquist'},...
                             'type',       {'image',      'array','boolean'},...
                             'dim_check',  {0,            1,0},...
                             'range_check',{[],           'R',[]},...
                             'required',   {1,            0,0},...
                             'default',    {'a',          1,1}...
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
   [image_in,trans,killNy] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
image_out = dip_shift(image_in,trans,killNy);
