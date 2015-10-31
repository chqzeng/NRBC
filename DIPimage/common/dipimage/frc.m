%FRC   Fourier Ring Correlation
%
% SYNOPSIS:
%  [avgfrc1, avgfrc2] = FRC(in)
%
% PARAMETERS:
%  in: stack of input images (at least two in one 3D image)
%
% OUTPUT:
%  avgfsc1: eq(2) from van Heel (sum(F_1F_2^*) / sqrt(sum|F_1|^2  * sum|F_2|^2) )
%  avgfsc2: eq(3) from van Heel (sum(F_1F_2^*) / sum(|F_1||F_2|) )
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
% May 2011, bug fix in normalization

function [avgfrc1, avgfrc2] = frc(in)

% Avoid being in menu
if nargin == 1 & ischar(in) & strcmp(in,'DIP_GetParamList')
   avgfrc1 = struct('menu','none');
   return
end

if ndims(in)~=3; error('dpr requires at least two images combined in a 3D image');end
if size(in,1) ~=size(in,2); error('Image must be square to perform angular average easily.');end
dq=1;
innerRadius=1;
sz = size(in);
N = sz(3);

resfrc1 = newim(size(in,1)/2+1,N-1);
resfrc2 = newim(size(in,1)/2+1,N-1);
for ii=0:N-2
   f1 = ft(ex_slice(in,ii));
   f2 = ft(ex_slice(in,ii+1));
   m1 = abs(f1);
   m2 = abs(f2);
   tmp = real(radialmean( f1*conj(f2),[],dq,innerRadius));
   resfrc1(:,ii) = tmp / sqrt( radialmean(m1^2,[],dq,innerRadius) * radialmean(m2^2,[],dq,innerRadius) );
   resfrc2(:,ii) = tmp / radialmean(m1*m2,[],dq,innerRadius);
end
avgfrc1 = mean(resfrc1,[],2);
avgfrc2 = mean(resfrc2,[],2);
