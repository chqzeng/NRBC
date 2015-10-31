%dip_exit   Terminates the DIPlib library
%   DIP_INITIALISE_LIBS must be called before using any of the DIPlib
%   functions. When DIPlib is no longer needed, a call to
%   DIP_EXIT will remove DIPlib from memory.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.
% 30 May 2004: Renamed the private MEX-file dip__initialise to avoid
%              confusing problems with dip_initialise.m .

function dip_exit
dip__initialise(0);
clear mex
