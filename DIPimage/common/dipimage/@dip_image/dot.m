%DOT   Dot product of two vector images.
%   DOT(A,B) returns the dot product of the vector images A and B.
%   If both A and B are column vectors, this is the same as A'*B.
%   The dot product results in a scalar image.
%
%   Either A or B can be a normal vector such as [1,0,0].
%
%   See also: INNER, OUTER, CROSS

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, December 2009.
% 24 June 2011:     Using PREPARETENSORS. (CL)

function out = dot(in1,in2)
try
   [tensorop,in1,in2] = preparetensors(in1,in2);
catch
   error(di_firsterr)
end
if ~tensorop
   error('Operation only defined for vector images.');
end
in1 = in1(:);
in2 = in2(:);
if prod(imarsize(in1))~=prod(imarsize(in2))
   error('Vector lengths do not match.');
end
out = in1'*in2;
