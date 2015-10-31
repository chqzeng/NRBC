%HCV2RGB   Convert color image from HCV to RGB

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
% Piet W. Verbeek
% adjusted Judith Dijk, June 2002.

function out= hcv2rgb(in)
%note that 0<RGB,C,V<255, 0<Hue<6

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

Value = in(3);           % Value = largest
Chroma = in(2);
Smallest = Value-Chroma; % Smallest
Hue = mod(in(1),6);

Hs = floor(Hue);         % Hue Sector, from 0 to 5
m = Hue - Hs;
Meven = Chroma * m + Smallest;
Modd = Chroma * (1-m) + Smallest;
Hs0 = +(Hs==0);
Hs1 = +(Hs==1);
Hs2 = +(Hs==2);
Hs3 = +(Hs==3);
Hs4 = +(Hs==4);
Hs5 = +(Hs==5);

out = dip_image('array',[3,1]);
out(1) = (Hs0+Hs5)*Value + (Hs2+Hs3)*Smallest + Hs1*Modd + Hs4*Meven;
out(2) = (Hs1+Hs2)*Value + (Hs4+Hs5)*Smallest + Hs3*Modd + Hs0*Meven;
out(3) = (Hs3+Hs4)*Value + (Hs0+Hs1)*Smallest + Hs5*Modd + Hs2*Meven;
out = di_setcolspace(out,in(1).color,'RGB');
