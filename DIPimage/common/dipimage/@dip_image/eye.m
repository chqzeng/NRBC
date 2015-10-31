%EYE   Identity tensor
%   EYE(A) creates a identity tensor with the specification of A.
%   Same dimensionality and sizes of images. The diagonal images
%   contain only 1's and the off-diagonal only 0's.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, November 2000.
% Nov 2002, change creation of null and eins image to be faster.
% 26 July 2007: Output is sfloat; reduced loop (CL).
% 1 October 2010: A little extra simplification (CL).

function out = eye(in)

if ~istensor(in)
   error('Image is not a tensor image');
end
s = imarsize(in);
if length(s)>2
   error('Only implemented for 2D tensors.');
end

out = dip_image('array',s);
out(:) = dip_image('zeros',imsize(in),'single');
for ii=1:min(s)
   out(ii,ii).data(:) = 1;
end
