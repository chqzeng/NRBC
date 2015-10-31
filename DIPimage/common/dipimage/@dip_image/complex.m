%COMPLEX   Construct complex image from real and imaginary parts.
%   COMPLEX(A,B) returns the complex result A + Bi, where A and B
%   are identically sized images of the same data type.
%
%   COMPLEX(A) returns the complex result A + 0i, where A must
%   be real.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% February 2008: Adding pixel dimensions and units to dip_image. (BR)
% 24 June 2011:  Not using DO1INPUT any more. New version of COMPUTE2. (CL)

function out = complex(in1,in2)
if nargin == 1
   out = in1;
   for ii=1:prod(imarsize(out))
      dt = out(ii).dip_type;
      if any(strcmp(dt,{'dcomplex','scomplex'}))
         % do nothing
      elseif strcmp(dt,'dfloat')
         out(ii).dip_type = 'dcomplex';
         out(ii).data = complex(out(ii).data);
      else
         out(ii).dip_type = 'scomplex';
         out(ii).data = complex(single(out(ii).data));
      end
   end
else % nargin == 2
   try
      out = compute2('complex',in1,in2);
   catch
      error(di_firsterr)
   end
end
