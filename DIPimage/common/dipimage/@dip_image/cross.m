%CROSS   Cross product of two vector images.
%   CROSS(A,B) returns the cross product of the vector images A and B.
%   The cross product results in a vector image, and is only defined
%   for vectors with 3 components.
%
%   Either A or B can be a normal vector such as [1,0,0].
%
%   See also: OUTER, INNER, DOT

% (C) Copyright 1999-2011               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger and Cris Luengo, July 2000.
% 10 December 2009: Renamed from OUTER to CROSS, OUTER is now a call
%                   to this function. Input vectors can have different
%                   orientations. (CL)
% 24 June 2011:     Using PREPARETENSORS. (CL)

function out = cross(in1,in2)
try
   [tensorop,in1,in2] = preparetensors(in1,in2);
catch
   error(di_firsterr)
end
if ~tensorop
   error('Operation only defined for vector images with 3 components.');
end
if prod(imarsize(in1))~=3 | prod(imarsize(in2))~=3
   error('Operation only defined for vector images with 3 components.');
end
out = dip_image('array',3);
out(1) = in1(2).*in2(3) - in1(3).*in2(2);
out(2) = in1(3).*in2(1) - in1(1).*in2(3);
out(3) = in1(1).*in2(2) - in1(2).*in2(1);
