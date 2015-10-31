%CTRANSPOSE   '   Complex conjugate transpose.   
%     X' is the complex conjugate transpose of X. 
%
% SEE ALSO:
%  transpose

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger, June 2006.
% 24 June 2011:  Not using DO1ARRAYINPUT any more. (CL)

function out = ctranspose(in)
sz = imarsize(in);
if length(sz)>2
   error('Complex transpose on ND arrays is not defined.');
end
out = dip_image('array',[sz(2),sz(1)]);
for ii=1:sz(2)
   for jj=1:sz(1)
      out(ii,jj) = conj(in(jj,ii));
   end
end
