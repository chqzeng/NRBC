%NUMEL   Number of elements in object.
%   NUMEL always returns 1 for an object of type DIP_IMAGE or
%   DIP_IMAGE_ARRAY. This is to circumvent a bug in MATLAB 6
%   (although the people at The MathWorks say it isn't).

% (C) Copyright 1999-2001               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, January 2001.
% 18 September 2001: Changed the input argument to VARARGIN to work
%                    with MATLAB 6.1.

function n = numel(varargin)
n = 1;
