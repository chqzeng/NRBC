%HORZCAT   Overloaded operator for [a b] or [a,b].

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2000.

function a = horzcat(varargin)
a = cat(1,varargin{:});
