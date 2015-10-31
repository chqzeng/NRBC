%ART2LAB   Convert color image from art to L*a*b*.
%    Example:
%    a1 = newim-0.1;
%    a2 = ceil(yy('corner')/51);
%    a3 = 359*xx('corner')/255;
%    a = joinchannels('art',a1,a2,a3)

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet Verbeek, Cris Luengo, August 2008.

function out = art2lab(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

artdata
hCIY_LUT = single(interp1(h_ART,h_CIY,0:359,'linear'));

plotz = in(1);
relring = in(2)/ring100;
hART = in(3);

%hCIE = dip_image(hCIY_LUT(double(round(hART+1))));
hCIE = lut(hART,hCIY_LUT);
hCIE = mod(hCIE+hCIE_Yellow,360)*(pi/180);
tmp = 100*(relring^chromapow);
CIE_a = tmp*cos(hCIE); % AH
CIE_b = tmp*sin(hCIE); % AR

% Instead of Lightness L we use the subjectively nicer lightness Measure M

Mspectrum = exp(-0.5*sigmayellow^-2*(mod(hART+180,360)-180).^2);
Mspectrum = dip_image(Mspectrum,'sfloat'); % EXP returns dfloat.
Mspectrum = (Lyellow-Lblue)*Mspectrum+Lblue;
Mspectrum = (Mspectrum/100)^pow;

%Mspectrum2 = exp(-0.5*sigmayellow^-2*(mod((1:360)+180,360)-180).^2);
%Mspectrum2 = (Lyellow-Lblue)*Mspectrum2+Lblue;
%Mspectrum2 = (Mspectrum2/100).^pow;
%Meqav = mean(Mspectrum2);
Meqav = 0.478112269733029;

%%% If you want to change these settings, please enable this next block
%%% of code in place of the bit that comes after:
% Greyripple = 0;
% Naturality = 1;
% Ccorrection = 0;
% Mspectrum = Naturality*(Mspectrum-Meqav)+Meqav;      % Naturality-factor reduces Mspectrum-amplitude
% Mgrey = Greyripple*Mspectrum+(1-Greyripple)*Meqav;   % C=0 behaviour: between constant and Mspectrum-following
% Mref = (1-relring)*Mgrey+relring*Mspectrum;          % interpolation between Mgrey and Mspectrum
% Mrefcorr = Mref+Ccorrection*relring;
%%%
Mrefcorr = (1-relring)*Meqav + relring*Mspectrum;
%%%

CIE_L = clip(plotz+Mrefcorr);
CIE_L = 100*CIE_L^(1/pow); % BB

out = di_joinchannels(in(1).color,'L*a*b*',CIE_L,CIE_a,CIE_b);
