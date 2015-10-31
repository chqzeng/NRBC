%EIG_LARGEST   Computes the largest eigenvector and value
%  V=EIG_LARGEST(A,SIGMA)
%  calculates the largest eigenvector V  of a square tensor
%  image A via the Power Method. Only 7 iterations are done, this should be
%  sufficient for most images
%
%  [V,LAMBDA]=EIG_LARGEST(A,SIGMA)
%  calculates the largest eigenvector V and value LAMBDA of a square
%  tensor image A via the Power Method.
%
%  DEFAULTS: SIMGA=0, i.e. no tensor smoothing. Otherwise the tensor is
%  smoothed by a Gaussian with width SIGMA. Without smoothing you may get
%  lots of warnings (Divide by zero), so warnings are surpressed for this
%  function.
%
%  See also: DIP_IMAGE/EIG, DIP_IMAGE/SVD

%  Power Method: G.H. Golub, C.F. van Loan in Matrix Computations p.406

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, November 2000
% Nov, 2002, made eigenvalue computation faster 

function [out_ev,out_ew] = eig_largest(A,sig)

if ~istensor(A)
   error('Image is not a tensor image.');
end
s = imarsize(A);
if s(1)~=s(2)
   error('Tensor must be square.')
end
if nargin == 2 %default no smoothing
   A = smooth(A,sig);
end

%make initial vector for iteration q=(1,1,1...1)'
q = dip_image('array',[s(1),1]);
tmp = dip_image('zeros',imsize(A));
tmp.data(:) = 1;
q(:) = tmp;

wa = warning;
warning('off');

% 7 iterations should be sufficient
for k=1:7
   q = A*q;
   q = q./norm(q);
end
out_ev = q;
if  nargout>=2
   out_ew = q'*(A*q);
end

warning(wa);
