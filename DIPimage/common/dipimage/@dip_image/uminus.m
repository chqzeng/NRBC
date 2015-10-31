%UMINUS   Overloaded operator for -a.

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2000.
% 30 June 2000:      On binary images, we now do not(a)
% 15 November 2002:  Fixed binary images to work in MATLAB 6.5 (R13)
% 10 March 2008:     Fixed bug. COMPUTE1 has a new PHYSDIMS input parameter.
% 10 September 2009: Works on tensor images also.
% 24 June 2011:      New version of COMPUTE1. (CL)

function img = uminus(img)
for ii=1:prod(imarsize(img))
   try
      if strcmp(img(ii).dip_type,'bin')
         %#function not
         img(ii) = compute1('not',img(ii),'bin');
      else
         img(ii) = compute1('uminus',img(ii));
      end
   catch
      error(di_firsterr)
   end
end
