%CROSSCORRELATION   Computes the cross-correlation between two images
%  as ft( ft(in1) * conj(ft(in2)) );
%
%
% SYNOPSIS:
%  image_out = crosscorrelation(image1, image2)
%

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Oct 2006.

function out = crosscorrelation(varargin)

d = struct('menu','Statistics',...
           'display','Cross-correlation',...
           'inparams',struct('name',       {'in1','in2'},...
                             'description',{'Input image 1','Input image 2'},...
                             'type',       {'image','image'},...
                             'dim_check',  {0,0},...
                             'range_check',{[],[]},...
                             'required',   {1,1},...
                             'default',    {'a','b'}...
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
   [in1,in2] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = dip_crosscorrelationft(in1,in2,'spatial','spatial','spatial');
%out = ft(ft(in1)*conj(ft(in2)));
if isreal(in1) & isreal(in2)
   out = real(out); %return real, through away the small round-off erros
end
