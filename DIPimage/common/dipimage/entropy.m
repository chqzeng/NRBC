%ENTROPY   Computes the entropy (in bits) of an image
%
% SYNOPSIS:
%  image_out = entropy(image_in, nBin)
%
% DEFAULT:
%  nBin = 256;
%
% SEE ALSO:
%  mutualinformation

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Oct 2006.

function out = entropy(varargin)

d = struct('menu','Statistics',...
           'display','Entropy',...
           'inparams',struct('name',       {'in','N'},...
                             'description',{'Input image','Number of histogram bins'},...
                             'type',       {'image','array'},...
                             'dim_check',  {0,0},...
                             'range_check',{[],'N+'},...
                             'required',   {1,0},...
                             'default',    {'a',256}...
                            ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Entropy'},...
                              'type',{'array'}...
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
   [in,N] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

c = diphist(in,[],N);
c = c/sum(c);
c(c==0)=[];
out = -sum(c .* log2(c));
