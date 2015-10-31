%GREY2RGB   Convert grey-value image to RGB color image.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, July 2008.

function out = grey2rgb(in)

if prod(imarsize(in)) ~= 1
   warning('Expected grey-value input. No conversion done.')
   out = in;
end

out = di_joinchannels(in(1).color,'RGB',in,in,in);
