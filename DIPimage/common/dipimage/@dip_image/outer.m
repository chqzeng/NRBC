%OUTER   Cross product of two vector images.
%   See CROSS

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Bernd Rieger and Cris Luengo, July 2000.
% 10 December 2009: Now calls CROSS, which contains the code that
%                   used to be in here. (CL)

function out = outer(in1,in2)
out = cross(in1,in2);
