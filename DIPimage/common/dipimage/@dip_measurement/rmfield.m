%RMFIELD   Remove a measurement from a dip_measurement object
%   M = RMFIELD(M,'measurmentID') removes 'measurmentID' from the
%   dip_measurement object M.

% (C) Copyright 1999-2009               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, March 2008.
% 18 December 2009:  Added 'axes' and 'units' elements.

function m = rmfield(m,id)
if nargin<2
   error('Measurement ID required')
end
I = find(strcmpi(m.names,id));
if isempty(I)
   error('Measurement not available')
end
m.data(I) = [];
m.names(I) = [];
m.axes(I) = [];
m.units(I) = [];
