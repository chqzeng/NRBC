%PINV Pseudoinverse..
%  X = PINV(A, TOL) 
%
%  X is of dimension A' and fullfills A*X*A = A, X*A*X = X.
%  The computation is based on SVD(A) and any
%  singular values less than a TOL are treated as zero.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Nov 2005.
% 26 July 2007: Removed use of NEWIMAR (CL).

function out = pinv(in,tol)
if ~istensor(in)
   error('SVD only for tensor images.');
end
sz = imarsize(in); %the size of the image matrix (must be 2D)
if length(sz)>2
   error('Pseudo inverse only allowed for 2D tensor images.');
end

[u,si,v] = dip_svd(in); %economic size decomposition 
if nargin<2
   tol = double(mean(max(imarsize(in)) * norm(in) * eps));
end
%make the inverse of the diagonal
s = dip_image('array',imarsize(si));
tmp = dip_image('zeros',imsize(in(1)));
for ii=1:prod(imarsize(s))
   s(ii) = tmp;
end
 %fill the diagonal of s, with the inverse of si
for ii=1:sz(2)
   tmp = si(ii,ii);
   mask = (tmp<tol);
   tmp = 1./tmp;
   tmp.data(mask) = 0;
   s(ii,ii) = tmp;
   clear tmp
end
out = v * s' * u';
