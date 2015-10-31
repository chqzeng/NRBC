%OVERLAY_CONFIDENCE   Overlay a grey-value image with a grey-value image
%
% SYNOPSIS:
%  image_out = overlay_confidence(signal, confidence, factor)
%
% PARAMETERS:
%  confidence: grey-value image between [0,1], where 1 is high confidence
%  factor: scaling of the intensity [0,1]
%
% DEFAULTS:
%  factor = .75;
%
% Image areas with 
%   low  confidence:  dark
%   high confidence: bright
%   low  signal    : green 
%   high signal    : white
%
% HINT: It maybe useful to scale your input data by square root or similar

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet Verbeek (idea), Bernd Rieger (code), Oct 2002.
% Nov 2002, new idea Piet, Lucas -> change ;-)

function out=overlay_confidence(varargin)

d = struct('menu','Display',...
  'display','Overlay image with confidence',...
  'inparams',struct('name',{'grey','conf','fac'},...
         'description',{'Grey  image','Confidence image','Factor'},...
         'type',       {'image','image','array'},...
         'dim_check',  {0,0,0},...
         'range_check',{[],[],[0,1]},...
         'required',   {1,1,0},...
         'default',    {'a','b',0.75}...
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
   [grey,conf,fac] = getparams(d,varargin{:});
catch
   if ~isempty(paramerror)
      error(paramerror)
   else
      error(firsterr)
   end
end

if min(conf) <0 | max(conf)>1
   warning('Confidence out of bounds. Rescaling to interval [0,1].');
   conf = stretch(conf,0,100,0,1);
end

if any(size(grey) ~= size(conf))
   error('Data and confidence not same size.');
end

%a = grey/max(grey)*255*fac;
%g = (1-conf)*255 + conf*a;
%out = joinchannels('RGB',a,g,a);

%2 method: betrouwbaar is licht, onbetrouwbaar is donker,
%          laag signaal is groen, hoog signaal is wit 

inten = stretch(grey,0,100,0,1); 
g = (255-(1-fac)*255*inten)*conf;
a = inten*255*fac*conf;
out = joinchannels('RGB',a,g,a);
