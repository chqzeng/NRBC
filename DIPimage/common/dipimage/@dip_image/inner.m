%INNER   Euclidean inner product of two tensor images.
%   INNER(A,B) returns the Euclidean inner product of the tensors
%   in the images A and B. Either A or B can be a numeric tensor.
%   The result is the same as that of the dot product for real-
%   valued tensors.
%
%   See also: DOT, OUTER, CROSS

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger and Cris Luengo, July 2000.
% 10 December 2009: Removed loop. (CL)
% 24 June 2011:     Using PREPARETENSORS. (CL)

function out = inner(in1,in2)
try
   [tensorop,in1,in2] = preparetensors(in1,in2);
catch
   error(di_firsterr)
end
if ~tensorop
   error('Operation only defined for tensor images.');
end
if ~isequal(imarsize(in1),imarsize(in2))
   error('Tensor sizes do not match.');
end
out = sum(in1.*in2);
