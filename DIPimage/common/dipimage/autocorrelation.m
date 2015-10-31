%AUTOCORRELATION   Computes the auto-correlation of an image
%  as out = ift( ft(in)*conj(ft(in)) )
%
% SYNOPSIS:
%  image_out = autocorrelation(image_in)
%

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Oct 2006.

function out = autocorrelation(varargin)

d = struct('menu','Statistics',...
           'display','Auto-correlation',...
           'inparams',struct('name',       {'in'},...
                             'description',{'Input image'},...
                             'type',       {'image'},...
                             'dim_check',  {0},...
                             'range_check',{[]},...
                             'required',   {1},...
                             'default',    {'a'}...
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
   [in] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

out = dip_crosscorrelationft(in,in,'spatial','spatial','spatial');
%fa=ft(in);
%out = real(ift( fa*conj(fa)));
if isreal(in)
   out = real(out); %return real, through away the small round-off erros
end
