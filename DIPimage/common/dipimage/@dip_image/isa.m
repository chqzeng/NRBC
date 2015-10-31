%ISA   True if object is of given class.
%   ISA(B,'dip_image') returns true if the object is a scalar image.
%
%   ISA(B,'dip_image_array') returns true if the object is an image array.

% (C) Copyright 1999-2010               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, June 1999.
% 25 July 2002: Test for type of TYPE to avoid weird error messages if
%               this function is called wrongly.
% 8 October 2010: Now smartly depends on DIP_IMAGE/CLASS.

function out = isa(in,type)
if ~ischar(type)
   error('Unknown command option.')
end
out = strcmp(class(in),type);
