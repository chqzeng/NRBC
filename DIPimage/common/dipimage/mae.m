%MAE   Mean absolute error
%
%  Returns  err = mean(abs(in1-in2))  for the pixels in <mask>. <mask> can
%  be an empty array to process all pixels.
%
% SYNOPSIS:
%  err = mae(in1,in2,mask)
%
% SEE ALSO:
%  mse, mre, lfmse, ssim, psnr, noisestd.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2009, based on mse.m.

function err = mae(varargin)

d = struct('menu','Statistics',...
           'display','Mean absolute error',...
           'inparams',struct('name',       {'in1',    'in2',    'mask'},...
                             'description',{'Image 1','Image 2','Mask Image'},...
                             'type',       {'image',  'image',  'image'},...
                             'dim_check',  {0,        0,        0},...
                             'range_check',{[],       [],       []},...
                             'required',   {1,        1,        0},...
                             'default',    {'a',      'b',      '[]'}...
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
   [in1,in2,mask] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if ~isempty(mask)
   if ~islogical(mask)
      error('Mask image must be binary')
   end
   in1 = in1(mask);
   in2 = in2(mask);
end
err = mean(abs(in1-in2));
