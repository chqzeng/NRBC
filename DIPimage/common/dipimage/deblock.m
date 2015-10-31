%DEBLOCK   Remove blocking artifact from JPEG compressed images
%
% SYNOPSIS:
%  out = deblock(in)
%
% EXAMPLE:
%  a = readim;
%  imwrite(uint8(a),'temp.jpg','jpg','Quality',10);
%  b = readim('temp.jpg');
%  c = deblock(b)
%  delete('temp.jpg')
%
% LITERATURE:
%  T.Q. Pham and L.J. van Vliet,  Blocking artifacts removal by a hybrid
%   filter method, Proc. 11th Annual Conf. of the Advanced School for
%   Computing and Imaging, ASCI, Delft, 2005, pp. 372-377.
 
% (C) Copyright 1999-2012               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Tuan Pham, December 2003.

function out = deblock(in)

if nargin == 1
   if ischar(in) & strcmp(in,'DIP_GetParamList')
      out = struct('menu','none');
      return
   end
end


% jpeg_quality_score range=[0 10] with 10 being best quality. 
jqs = min(max(0,jpeg_quality_score(in)),10); % the score could get slightly>10

% the certainty image: 1 everywhere, <1 at block boundaries
block = newim([8 8])+jqs/10; block(1:6,1:6) = 1;
mask = repmat(block,ceil(size(in)/8));
c = gaussf(mask(0:size(in,1)-1,0:size(in,2)-1)); c = c/max(c);

% if input is perfect, s1d should be close to 0 to avoid blurring
s1d = (10-jqs)/7.5;   % 7.5 is better than 10 for low bit-rate (connect lines better)
[p,q] = structuretensor(in,1,s1d,{'orientation','anisotropy'});
curv = curvature(in,'line',1,s1d);   % may skip this for speed
d = arcf(in,newimar(p,s1d*q,curv));

% for low freq region, use simple Gaussian smoothing, 
s2d = (10-jqs)/2;     % sigma_2D range=[0 5]
e = gaussf(in,s2d);  

% normalized convolution to reduce blocking effect on gradmag
g = gaussf(sqrt(dx(in)^2 + dy(in)^2),s2d)/gaussf(c,s2d);    

% Gaussian error norm, Haglund SCIA'03 paper use sigmoid
w = exp(-g/median(g)/max(1,s2d-1));      
out = d*(1-w) + e*w ;

% compensate for interpolation blur caused by arcf
out = out - laplace(out)/2;
