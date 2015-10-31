%HCV2HSV   Convert color image from HCV to HSV

% (C) Copyright 1999-2002               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
% Piet W. Verbeek
% adjusted Judith Dijk, June 2002.
%
% 17 March 2004: Fixed bug probably introduced when binary images no
%                longer contained logical arrays (CL).

function out = hcv2hsv(in)
%note that 0<Value, Chroma<255, 0<Hue<6, 0<Saturation<1

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

Value = in(3);
I = Value==0;
Value.data(I) = 1;
Saturation = in(2) / Value;  % Saturation = Chroma / Value
Saturation.data(I) = 0;

out = di_joinchannels(in(1).color,'HSV',in(1),Saturation,in(3));
