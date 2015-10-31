%OUT = COMPUTE0ARRAY(OPERATION,IN)
%    This applies OPERATION on each tensor in the image:
%    IN{1} OPERATION IN{2} OPERATION IN{3} ...
%
%    This function should be called after DOARRAYINPUTS if the ARRAYOP
%    flag returned was non-zero (true).
%
%    Be careful!!!!
%    This function only works for operations that are "separable",
%    like MAX, MIN and PLUS.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.
% 18 January 2001: Keeping the maximum dimensionality.
% 10 March 2008:   Fixed bug. COMPUTE2 has a new PHYSDIMS input parameter.
% 24 June 2011:    New version of COMPUTE2. (CL)

function out = compute0array(operation,in)
if nargin ~= 2
   error('Erroneus input.')
end
out = in(1);
for ii=2:prod(imarsize(in))
   out = compute2(operation,out,in(ii));
end
