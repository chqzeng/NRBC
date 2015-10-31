%RGB2HCV   Convert color image from RGB to HCV

% (C) Copyright 1999-2004               Pattern Recognition Group
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

function out = rgb2hcv(in)
%note that 0<RGB,C,V<255, 0<Hue<6

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

Value = max(in);         % Value = largest
Smallest = min(in);
Chroma = Value-Smallest; % grey has Chroma=0

M = in(1)+in(2)+in(3)-Value-Smallest;
C = Chroma;
I = C==0;
C.data(I) = 1;
m = (M-Smallest)/C;
m.data(I) = 0;

% Hue = condition*m + (1-condtion)*Hue = Hue + condition*(m-Hue)
Hue = Chroma;                                           %declaration only
Hue = Hue+((in(1)==Value)&(in(3)==Smallest))*(m-Hue);   % 0-1 red yellow
Hue = Hue+((in(2)==Value)&(in(3)==Smallest))*(2-m-Hue); % 1-2 yellow green
Hue = Hue+((in(2)==Value)&(in(1)==Smallest))*(2+m-Hue); % 2-3 green cyan
Hue = Hue+((in(3)==Value)&(in(1)==Smallest))*(4-m-Hue); % 3-4 cyan blue
Hue = Hue+((in(3)==Value)&(in(2)==Smallest))*(4+m-Hue); % 4-5 blue magenta
Hue = Hue+((in(1)==Value)&(in(2)==Smallest))*(6-m-Hue); % 5-6 magenta red
%Hue=Hue-6*(Hue>=6);
Hue = mod(Hue,6);

out = di_joinchannels(in(1).color,'HCV',Hue,Chroma,Value);
