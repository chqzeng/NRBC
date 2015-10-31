%HYPOT   Robust computation of the square root of the sum of squares.
%  HYPOT(A,B) returns SQRT(ABS(A).^2+ABS(B).^2) carefully computed to
%  avoid underflow and overflow.

% (C) Copyright 2010-2011, All rights reserved.
% Cris Luengo, August 2010.
%
% 24 June 2011: New version of COMPUTE2. (CL)

function out = hypot(in1,in2)
try
   out = compute2('hypot',in1,in2);
catch
   error(di_firsterr)
end
