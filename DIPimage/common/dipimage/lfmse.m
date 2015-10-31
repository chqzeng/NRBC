%LFMSE   Linear fitted mean square error
%
% Like MSE, except that it first does a linear mapping of the greyvalues
% of IN2 to minimize the mean square error between IN1 and IN2.
%
% SYNOPSIS:
%  err = lfmse(in1,in2,mask)
%
% SEE ALSO:
%  mse, mae, mre, ssim, psnr, noisestd.


% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, October 2005, adapted from MSE

function err = lfmse(varargin)

d = struct('menu','Statistics',...
           'display','Linear fitted MSE',...
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

in1 = double(in1); in1 = in1(:);
in2 = double(in2); in2 = in2(:);
vals = [in2,ones(length(in2),1)]\in1;
in2 = vals(1) * in2 + vals(2);

err = mean((in1-in2).^2);
