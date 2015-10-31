%UPLUS   Overloaded operator for +a.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2000.
% 30 June 2000: Completely revamped! Doesn't do anything anymore!
% 12 October 2000: Completely revamped again! If input is binary, output will
%                  be uint8 (removes logicalness).
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)
% 10 September 2009: Works on tensor images also.

function in = uplus(in)
for ii=1:prod(imarsize(in))
   if strcmp(in(ii).dip_type,'bin')
      in(ii).dip_type = 'uint8';
   end
end
