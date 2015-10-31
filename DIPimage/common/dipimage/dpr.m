%DPR   Differential phase residuals
%  The average DPR for noise is pi/sqrt(3) = 1.8 = 104 degrees
%  The phase differences are mapped into an interval of -pi,+pi. This
%  results in a uniform distribution in this interval.
%
% SYNOPSIS:
%  [avgdpr1, avgdpr2, avgdpr3, avgdpr4, resdpr_img] = dpr(in)
%
% PARAMETERS:
%  in: stack of (aligned) input images (at least two in one 3D image)
%
% OUTPUT:
%  avgdpr1: eq(1) from van Heel: sqrt( (mean(|F_1|+|F_2|) dphi^2) / (mean |F_1|+|F_2|) )
%  avgdpr2: |dphi| 
%  avgdpr3: eq(4) from van Heel: sqrt( (sum(|F_1|*|F_2|) dphi^2) / (sum |F_1|*|F_2|) )
%  avgdpr4: eq(5) from van Heel: (sum(|F_1|*|F_2|) dphi) / (sum |F_1|*|F_2|)
%           where F is the Fourier transform of image pairs
%
% LITERATURE:
%   M. van Heel, Similarity measures between images, Ultramicroscopy, 21:95-100, 1987. 
%   M. van Heel and M. Schatz, Fourier shell correlation threshold criteria, Journal of Structural Biology, 151:250-262, 2005. 

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Feb 2010

function [avgdpr1, avgdpr2, avgdpr3, avgdpr4, resdpr_img] = dpr(in)

% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   avgdpr1 = struct('menu','none');
   return
end

if ndims(in)~=3; error('dpr requires at least two images combined in a 3D image');end
if size(in,1) ~=size(in,2); error('Image must be square to perform angular average easily.');end
dq=1;
innerRadius=1;

sz = size(in);
N = sz(3);

resdpr1 = newim(size(in,1)/2+1,N-1);
resdpr2 = newim(size(in,1)/2+1,N-1);
resdpr3 = newim(size(in,1)/2+1,N-1);
resdpr4 = newim(size(in,1)/2+1,N-1);
%resdpr5 = newim(size(in,1)/2+1,N-1);
%resdpr6 = newim(size(in,1)/2+1,N-1);
if nargout>4;resdpr_img = newim(sz-[0 0 1]);end
for ii=0:N-2
   %fprintf('processing %d/%d\n',ii,N-2)
   f1 = ft(ex_slice(in,ii));
   f2 = ft(ex_slice(in,ii+1));
   m1 = abs(f1);
   m2 = abs(f2);
   dphi  = phase(f1)-phase(f2);
   dphi = niceangle(dphi,-pi,pi); %shift the angle back into an interval of -pi,+pi
   dphi2 = dphi*dphi; 
   
   no = radialmean(m1*m2,[],dq,innerRadius);
   noplus = m1+m2;  
   %resdpr5(:,ii) = sqrt( radialmean( noplus*dphi2 ,[],dq,innerRadius)     / radialmean(noplus,[],dq,innerRadius) );
   resdpr1(:,ii) = sqrt( radialsum(  noplus*dphi2 ,dq,innerRadius) / radialsum( noplus,dq,innerRadius) );
   
   resdpr2(:,ii) = radialmean(abs(dphi),[],dq,innerRadius);
   resdpr3(:,ii) = sqrt( radialmean( (m1*m2)*dphi2 ,[],dq,innerRadius)) / no;
   resdpr4(:,ii) = radialmean( (m1*m2)*abs(dphi) ,[],dq,innerRadius) / no;  
   %resdpr6(:,ii) = sqrt( radialsum(  noplus*imagic_dphi*imagic_dphi ,dq,innerRadius) / radialsum( noplus,dq,innerRadius) );
   
   if nargout >4;resdpr_img(:,:,ii) = abs(dphi);end
end

avgdpr1 = mean(resdpr1,[],2);
avgdpr2 = mean(resdpr2,[],2);
avgdpr3 = mean(resdpr3,[],2);
avgdpr4 = mean(resdpr4,[],2);
%avgdpr5 = mean(resdpr5,[],2);
%avgdpr6 = mean(resdpr6,[],2);


%niceangle restricts the angles in the image to an interval
%
% SYNOPSIS:
%  image_out = niceangle(image_in, lowBound, highBound)
%
% PARAMETERS:
%   lowBound  : lower interval bound 
%   highBound : higher interval bound
function out = niceangle(in, Blow, Bhigh)
out = in;
m = out > Bhigh;
while any(m)
    out(m) = out(m) - 2*pi;
    m = out > Bhigh;
end
m = out < Blow;
while any(m)
    out(m) = out(m) + 2*pi;
    m = out < Blow;
end





