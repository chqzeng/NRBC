%ARCF   Arc-shape filter (1d oriented & curved Gaussian/bilateral filter)
%
% SYNOPSIS:
%  out = arcf(in,params,tonalSigma,trunc)
%
% PARAMETERS:
%  in = image OR image array (all are then filter with same parameters)
%  params = image array of {orientation,sigma,[curv],[bilateral_init]}
%  tonalSigma = sigma of the Gaussian filter in tonal axis
%  trunc = truncation of the spatial Gaussian filter 
%
% DEFAULTS:
%  params = computed from the first image (see Matlab code)
%  tonalSigma = 0    % spatial filter only
%  trunc = 3
%
% EXAMPLE:
%  a = noise(readim,'gaussian',60)     % very noisy Erika
%  b = arcf(a)       % nice worms all around her
%
% LITERATURE: 
%  T.Q. Pham and L.J. van Vliet.  Blocking artifacts removal by
%   a hybrid filter method, submitted 
%
% SEE ALSO: hybridf, bilateralf, gaussf_adap

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.

function out = arcf(in,params,tonalSigma,truncation)

if nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end


s = 2;
if nargin<2 | isempty(params) 
   [phi,l2] = structuretensor(in{1},1,s,{'orientation','l2'}); 
   sn = noisestd(in{1})/5;   % noise-dependent correction term for the error norm
   params = dip_image({phi,s*exp(-l2/median(l2)/sn)}); % coherence enhancement
else
   if length(params)==1  
      params = dip_image({params,newim(in{1})+s}); % default sigma=2, no curv
   end
end
if nargin<3 | isempty(tonalSigma) tonalSigma=0; end  % spatial filter only
if nargin<4 | isempty(truncation) truncation=3; end

% bspline interpolation is a bit sharper but much slower
out = dip_arcfilter(in,params,tonalSigma,truncation,'linear');   
