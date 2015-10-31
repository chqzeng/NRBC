%OUT = DI_DEFAULTWHITE

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo 2008.
% 20 Augustus 2009: Computed from XYZDATA.

function out = di_defaultwhite
% D65, 2 graden waarnemer, standaard
%out = [0.9505 1 1.0888];
out = xyzdata * [1;1;1];
