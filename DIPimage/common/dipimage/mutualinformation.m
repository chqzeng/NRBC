%MUTUALINFORMATION   Computes the mutual information (in bits) of two images
%
% The histogram is used to generate the probaility distributions. 
% This is a choice, could also use Parzen Window etc.
%
% SYNOPSIS:
%  out = mutualinformation(image1, image2, nBin)
%
% DEFAULT:
%  nBin = 256;
%
% SEE ALSO:
%  entropy.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Oct 2006.

function out = mutualinformation(varargin)

d = struct('menu','Statistics',...
           'display','Mutual information',...
           'inparams',struct('name',       {'in1','in2','N'},...
                             'description',{'Input image 1','Input image 2','Number of histogram bins'},...
                             'type',       {'image','image','array'},...
                             'dim_check',  {0,0,0},...
                             'range_check',{[],[],'N+'},...
                             'required',   {1,1,0},...
                             'default',    {'a','b',256}...
                            ),...
           'outparams',struct('name',{'out'},...
                              'description',{'Mutual information'},...
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
   [in1,in2,N] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end
if any(size(in1)~=size(in2))
   error('Images sizes do not match.');
end

w=warning;
warning('off');

c1 = diphist(in1,'all',N);
c1 = c1/sum(c1);
c2 = diphist(in2,'all',N);
c2 = c2/sum(c2);

c12 = dip_image( double(c1)'*double(c2)); %generate outer product
h2 = diphist2d(in1,in2,[],[],[],N,N);
h2 = h2/sum(h2);

tmp = h2/c12; %remove /0 and log 0
tmp(c12==0)=1;
tmp(tmp==0)=1;

out = sum( h2*log2(tmp));

warning(w);
