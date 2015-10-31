%S = FIRSTERR
%    Gets the original error message.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, May 2000.
% 13 October 2000: Removed danger of infinite recursion by removing call
%                  to DIPGETPREF.
% 7 April 2001:    Removed call to FIRSTERR in DIPGETPREF. Calling it again!
% 31 August 2007:  Added SKIPTEST parameter.
% 12 March 2008:   Fixed bug introduced in the last change.

function s = firsterr(skiptest)

s = lasterr;

if nargin<1
   skiptest = 0;
end

value = 0;
if ~skiptest
   try
      value = dipgetpref('DebugMode');
   end
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
