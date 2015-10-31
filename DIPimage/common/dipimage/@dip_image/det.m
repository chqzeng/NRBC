%DET   Determinant of a tensor image.
%   DET(A) returns the determinant of the square tensors in the
%   dip_image_array A.
%
%   DET can be very ineficient for larger tensor sizes.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger and Cris Luengo, July 2000.
% November 2002:    4x4 deteriments added (BR)
% 10 December 2009: Using the Laplace method instead of writing out
%                   the 3x3 and 4x4 cases.

function out = det(in)
if ~istensor(in)
   error('Image is not a tensor image.');
end
s = imarsize(in);
if length(s) ~= 2 | s(1) ~= s(2)
   error('Tensor must be square.')
end
if s(1)==1
   out = in;
else
   out = dip__det(in);
end


% Computing the determinant with the Laplace method
function out = dip__det(in)
d = imarsize(in);
d = d(1);
if d==2
   out = in(1,1)*in(2,2) - in(2,1)*in(1,2);
else
   out = dip__det(in(2:d,2:d)) * in(1,1);
   for ii=2:d
      k = 1:d;
      k(ii) = [];
      out = out + dip__det(in(2:d,k)) * in(1,ii) * (-1)^(ii+1);
   end
end
