%MATLABVER_GE   Checks against the MATLAB version.
%    MATLABVER_GE([MAJOR,MINOR]) returns true if the MATLAB
%    version number is at least MAJOR.MINOR.
%    MATLABVER_GE([]) returns the version number as
%    [MAJOR,MINOR].

% (C) Copyright 1999-2009               All rights reserved
%
% Cris Luengo, December 2009.
% Copy of the function in DIPIMAGE/PRIVATE

function r = matlabver_ge(tv)

persistent cv;
if isempty(cv)
   cv = version;
   I = find(cv=='.');
   if length(I)>1
      cv = cv(1:I(2)-1);
   elseif length(I)<1
      cv = [cv,'.0'];
   end
   cv = sscanf(cv,'%d.%d');
end

if isempty(tv)
   r = cv;
else
   r = 0;
   if ( cv(1)>tv(1) ) | ( cv(1)==tv(1) & cv(2)>=tv(2) )
      r = 1;
   end
end
