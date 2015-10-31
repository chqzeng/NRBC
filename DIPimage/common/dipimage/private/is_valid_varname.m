%IS_VALID_VARNAME(NAME)
%    Check variable name for validity.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, November 2000.

function v = is_valid_varname(name)

start = '_ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
other = [start,'0123456789'];

v = 0;
if ~ischar(name), return, end
if length(name)<1, return, end
if ~any(start==name(1)), return, end
if ~all(ismember(name(2:end),other)), return, end
v = 1;
