%SVD Singular value decomposition.
%  [U,S,V] = SVD(X) 
%
%  S = SVD(X) returns a vector image containing the singular values.
%
%  Computes the "economy size" decomposition.
%  If X is m-by-n with m >= n, then only the
%  first n columns of U are computed and S is n-by-n.
%
%  See also: DIP_IMAGE/EIG, DIP_IMAGE/EIG_LARGEST

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, Nov 2005.
% 26 July 2007: Removed use of NEWIMAR (CL).
% 22 July 2010: Simplified due to improved DIP_SVD. (CL)

function [u,s,v] = svd(in)

if ~istensor(in)
   error('SVD only for tensor images.');
end
sz = imarsize(in);
if length(sz)~=2
   error('SVD only for 2D matrices.');
end

if nargout<=1
   u = dip_svd(in);
elseif nargout==3
   [u,s,v] = dip_svd(in);
else
   error('Wrong number of output arguments.');
end
