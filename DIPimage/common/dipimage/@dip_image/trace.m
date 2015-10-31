%TRACE   Sum of the diagonal elements
%    TRACE(A) is the sum of the diagonal elements of the tensor image

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, November 2000.
% 27 June 2011: Making sure the tensor is 2D. Avoiding the initial zeros image. (CL)

function out = trace(a)
if ~istensor(a)
   error('Input should be a tensor image.')
end
sz = imarsize(a);
if length(sz)~=2 | sz(1)~=sz(2)
   error('Tensor image should be square.');
end
out = a(1,1);
for ii=2:sz(1)
   out = out+a(ii,ii);
end
