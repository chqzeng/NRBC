%ISLOGICAL   True for binary image.
%   ISLOGICAL(B) returns true if B is a binary image.

% (C) Copyright 1999-2007               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, August 1999.
% 15 November 2002: Fixed binary images to work in MATLAB 6.5 (R13)

function out = islogical(in)
if ~isscalar(in), error('Parameter "in" is an array of images.'), end
out = strcmp(in.dip_type,'bin');
