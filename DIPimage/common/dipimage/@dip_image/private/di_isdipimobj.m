%DI_ISDIPIMOBJ(A)
%    Returns true if A is of class DIP_IMAGE. This is different from
%    ISA or CLASS because those have been overloaded to support the
%    difference between a DIP_IMAGE and a DIP_IMAGE_ARRAY.

% (C) Copyright 2007-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, April 2007.

function b = di_isdipimobj(a)
%#function isa
b = builtin('isa',a,'dip_image');
