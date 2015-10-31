%HYBRIDF    Denoise by a soft blending of arc filter and Gaussian filter
%  (arc filter is a 1D curved filter that aligns with local orientation)
%
% SYNOPSIS:
%  out = hybridf(in,s1,s2)
%
% PARAMETERS
%  s1 = max scale for the 1D arc filter
%  s2 = scale for the 2D Gaussian filter
%
% EXAMPLE
%  a = noise(readim,'gaussian',20)
%  b = hybridf(a)    % much more real
%  c = pmd(a,15)     % compared to this
%
% LITERATURE
%  T.Q. Pham & L.J. van Vliet, Blocking artifacts removal by a 
%   hybrid filter method. Summitted to ECCV2004
%
% SEE ALSO: arcf, gaussf_adap, deblock

% T.D.Pham, An image restoration by fusion, PR 34-12, Dec2001, 2403-1411
% also do this kind of fusion, but b/w Gaussian & Wiener, which does not
% enhance edges

% (C) Copyright 1999-2003               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.

function out = hybridf(in,s1,s2,w0)

if nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end


if nargin<2 | isempty(s1)   s1 = max(0,sqrt(noisestd(in))/3-0.5); end
if nargin<3 | isempty(s2)   s2 = s1+1.5; end
if nargin<4 | isempty(w0)   w0 = max(1,s1); end

% the arc filter. May skip curvature for speed
[p,q] = structuretensor(in,1,s1,{'orientation','anisotropy'});
curv = curvature(in,'line',1,s1);   % may skip this for speed
b = arcf(in,newimar(p,s1*q,curv));  % q^0.5 oversmooth, q^2 underfilter

% the isotropic Gaussian filter
c = gaussf(in,s2);

% the blending weight, assume Gaussian noise -> Gausian error norm
d = gaussf(gradmag(in,1),(s1+s2)/2);   % get some offset due to noise
w = exp(-d/median(d)/w0);    % w0 = Gaussian error norm correction 
m = dip_percentile(w,[],5,[1 1]);
w = (w-m)/(dip_percentile(w,[],95,[1 1])-m);  % normalize 90% of w to [0 1]

% the hybrid filter
out = b*(1-w) + c*w;
