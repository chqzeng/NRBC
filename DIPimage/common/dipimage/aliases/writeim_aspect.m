%WRITEIM_ASPECT   Write grey-value or color image to ICS file with aspect ratio
%
% SYNOPSIS:
%  writeim_aspect(image_in,filename,aspect,compression)
%
% NOTE:
%  This is now an alias for:
%  writeim(image_in,filename,'ICSv2',compression,aspect)

% (C) Copyright 1999-2006               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, January 2005, based on WRITEIM.
% 3 February 2005: 'aspect' parameter didn't work with image arrays.
% 24 July 2006:    Put code into WRITEIM, made an alias of this.

function out = writeim_aspect(image_in,filename,aspect,compression)
if nargin<3
   error('Too few parameters given')
end
if nargin<4
   compression = 1;
end
out = writeim(image_in,filename,'ICSv2',compression,aspect)
