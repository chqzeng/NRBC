%IMAG   The imaginary part of pixel values.
%   IMAG(B) returns the imaginary part of each pixel in B.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 13 March 2006: Avoid calling DIP_IMAGE, it squeezes data.
% 27 June 2011:  Now works on image arrays.

function in = imag(in)
for ii=1:imarsize(in)
   if di_iscomplex(in(ii))
      in(ii).data = imag(in(ii).data);
      in(ii).dip_type = [in(ii).dip_type(1),'float'];
   else % return empty image
      in(ii).data(:) = 0;
   end
end
