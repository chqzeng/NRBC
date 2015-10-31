%ISFIELD   True if measurement is in dip_measurement object
%   F = ISFIELD(M,'measurmentID') returns true if 'measurmentID' is the
%   name of a measurement in dip_measurement object M.

% (C) Copyright 1999-2005               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2005.

function f = isfield(m,id)
if nargin<2
   error('Measurement ID required')
end
f = strcmpi('id',id) | any(strcmpi(m.names,id));
