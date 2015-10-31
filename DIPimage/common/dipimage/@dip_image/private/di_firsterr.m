%S = DI_FIRSTERR
%    Gets the original error message.

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 13 October 2000: Removed danger of infinite recursion by removing call
%                  to dipgetpref.
% 7 April 2001: That last change was actually a bug!

function s = di_firsterr

s = lasterr;

try
   value = dipgetpref('DebugMode');
catch
   value = 0;
end
if value
   while s(end)==10
      s=s(1:end-1);
   end
   I = find(s == 10);
   if ~isempty(I)
      s = s(I(end)+1:end);
   end
end
