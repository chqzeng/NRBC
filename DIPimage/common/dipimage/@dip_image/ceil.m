%CEIL   Round towards plus infinity.
%   CEIL(B) rounds the pixel values of B towards the nearest integers
%   towards plus infinity.
%   The returned image is of type 'sint32' if B is any float type. The
%   function fails on complex types and does nothing on integer types.
%   Note that clipping occurs if the result doesn't fit in a value of
%   type 'sint32'.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 2000.
% 10 March 2008: Fixed bug. COMPUTE1 has a new PHYSDIMS input parameter.
% 24 June 2011:  Rewritten for new version of COMPUTE1. (CL)

function img = ceil(img)
for ii=1:prod(imarsize(img))
   if di_iscomplex(img(ii))
      error('Cannot create an integer value from a complex value.')
   elseif strcmp(img(ii).dip_type(2:end),'float')
      try
         img(ii) = compute1('ceil',img(ii),'sint32');
      catch
         error(di_firsterr)
      end
   end
end
