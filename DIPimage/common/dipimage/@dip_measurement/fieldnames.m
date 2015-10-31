%FIELDNAMES   Get measurement names.
%   NAMES = FIELDNAMES(S) returns the names of the measurements
%   in the dip_measurement object S, as a cell array of strings.
%
%   These names can be used by evaluating S.NAME.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function out = fieldnames(in)
out = in.names;
