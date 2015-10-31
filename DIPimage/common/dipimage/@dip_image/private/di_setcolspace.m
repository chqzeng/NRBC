%OUT = DI_SETCOLSPACE(IN,COLSTRUCT,SPACESTRING)
%    Set the color space information to the given COL structure and SPACE
%    string. COL can be [], and SPACE can be ''.
%
%    Examples:
%       OUT = DI_SETCOLSPACE(OUT,OUT.COLOR,'RGB')
%       OUT = DI_SETCOLSPACE(OUT,[],'RGB')
%       OUT = DI_SETCOLSPACE(OUT,[],'')

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 2002.

function in = di_setcolspace(in,col,space)
if nargin ~= 3 | ~di_isdipimobj(in), error('Wrong input.'), end
if ~ischar(space)
   error('Wrong input.')
end
if isempty(col)
   col = struct('space',space);
elseif ~isstruct(col)
   error('Wrong input.')
else
   col.space = space;
end
[in.color] = deal(col);
