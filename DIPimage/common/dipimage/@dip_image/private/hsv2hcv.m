%HSV2HCV   Convert color image from HSV to HCV

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
% Piet W. Verbeek
% adjusted Judith Dijk, June 2002.

function out = hsv2hcv(in)
%note that 0<Value, Chroma<255, 0<Hue<6, 0<Saturation<1

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

out = di_joinchannels(in(1).color,'HCV',in(1),in(2)*in(3),in(3)); % Chroma = Saturation * Value
