%EIG   Eigenvalues and eigenvectors of a symmetric tensor image
%  E = EIG(A) is a vector image containing the eigenvalues of the
%  square and symmetric tensors in image A. The values in E are
%  sorted in descending order, so that E{1} contains the largest
%  eigenvalue.
%
%  [V,D] = EIG(A) returns a diagonal matrix D of eigenvalues and
%  a matrix V whose columns are the corresponding eigenvectors,
%  so that A*V = V*D.
%
%  A must be a square 2x2 or 3x3 matrix, and must be symmetric.
%  That is, A{1,2} == A{2,1}. Only the upper triangle is used,
%  elements of the lower triangle are supposed to be equal.
%
%  See also: DIP_IMAGE/EIG_LARGEST, DIP_IMAGE/SVD

% (C) Copyright 2010, Cris Luengo, 28 November 2010.
% Centre for Image Analysis, Uppsala, Sweden.
% 17 October 2012: Fixed two typos for the 3x3 case with 2 outputs.

function [v,d] = eig(A)
%#function cat
if ~istensor(A)
   error('Image is not a tensor image.');
end
s = imarsize(A);
if s(1)~=s(2)
   error('Tensor must be 2x2 or 3x3.')
end
switch s(1)
   case 2
      if nargout==2
         [l1,v1,l2,v2] = dip_symmetriceigensystem2(A(1,1),A(1,2),A(2,2),{'l1','v1','l2','v2'});
         v = builtin('cat',2,v1,v2);
         d = diag(dip_image({l1,l2}));
      else
         [l1,l2] = dip_symmetriceigensystem2(A(1,1),A(1,2),A(2,2),{'l1','l2'});
         v = dip_image({l1,l2});
      end
   case 3
      if nargout==2
         [l1,v1,l2,v2,l3,v3] = dip_symmetriceigensystem3(A(1,1),A(1,2),A(1,3),A(2,2),A(2,3),A(3,3),...
                               {'l1','v1','l2','v2','l3','v3'});
         v = builtin('cat',2,v1,v2,v3);
         d = diag(dip_image({l1,l2,l3}));
      else
         [l1,l2,l3] = dip_symmetriceigensystem3(A(1,1),A(1,2),A(1,3),A(2,2),A(2,3),A(3,3),...
                      {'l1','l2','l3'});
         v = dip_image({l1,l2,l3});
      end
   otherwise
      error('Tensor must be 2x2 or 3x3.')
end
