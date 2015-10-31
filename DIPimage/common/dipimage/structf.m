%STRUCTF   Structure adaptive filter (oriented, variable-sized Gaussian filtering)
%
% SYNOPSIS:
%  out = structf(in,st,params,trunc)
%
% PARAMETERS:
%  st tensor smoothing
%  params = image tensor of {orientation,sigma_v,sigma_u,[curv]}
%  trunc = truncation of the spatial Gaussian filter 
%
% DEFAULTS:
%  st =2
%  params= computed using structuretensor, curvature is not used
%  trunc = 3
%
% EXAMPLE:
%  a = noise(readim,'gaussian',10)     % noisy Erika
%  b = structf(a)       
%  c = arcf(a)       
%
% LITERATURE: 
%  T.Q. Pham & L.J. van Vliet, Normalized averaging using adaptive applicability 
%   functions with applications in image reconstruction from sparsely and randomly 
%   sampled data, in: J. Bigun, T. Gustavsson (eds.), Image Analysis - SCIA 2003 
%   (Proc. 13th Scandinavian Conf. Halmstad, Sweden, June 29-July 2), 
%   LNCS vol. 2749, Springer Verlag, Berlin, 2003, 485-492
%
% SEE ALSO: arcf, hybridf, bilateralf, gaussf_adap

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.

function out = structf(in,st,params,truncation)

if nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end
if nargin<2 st = 2;end
if nargin<3 | isempty(params) 
   [p,r,q,l1,l2] = structuretensor(in,1,st,{'orientation','energy','anisotropy','l1','l2'});

   sn = noisestd(in)/5;   % noise-dependent correction term for the error norm
   sv = st*exp(-l2/median(l2)/sn);      % Gaussian error norm
   su = st*exp(-l1/median(l1)/sn)/1.5;  % make perpendicular scale smaller 
   params = dip_image({p,sv,su});      % this is 1 way to choose su,sv, 
else
   if length(params)==1  
      params = dip_image({params,newim(in)+2,newim(in)+0}); % default sv=2, su=0, no curv
   elseif length(params)==2  
      params = dip_image({params,newim(in)+0}); % default sv=2, su=0, no curv
   end
end
if nargin<4 | isempty(truncation) truncation=3; end

% separable structure adaptive filtering, not yet documented, 
tmp = dip_arcfilter(in,newimar(params{1},params{2}),-1,truncation,'linear');
out = dip_arcfilter(tmp,newimar(params{1}+pi/2,params{3}),-1,truncation,'linear');
