%LAB2ART   Convert color image from L*a*b* to art.

% (C) Copyright 1999-2008               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Piet Verbeek, Cris Luengo, August 2008.

function out = lab2art(in)

if prod(imarsize(in)) ~= 3
   warning('Expected three components. No conversion done.')
   out = in;
end

artdata
hART_LUT = single(interp1(h_CIY,h_ART,0:359,'linear'));

CIE_L = in(1);
CIE_a = in(2);
CIE_b = in(3);

relring = (sqrt(CIE_a^2+CIE_b^2)/100)^(1/chromapow);
hCIE = (180/pi)*atan2(CIE_b,CIE_a);
hCIE = floor(mod(hCIE-hCIE_Yellow,360));
%hART = dip_image(hART_LUT(double(round(hCIE+1))));
hART = lut(hCIE,hART_LUT);

% Instead of Lightness L we use the subjectively nicer lightness Measure M

Mspectrum = exp(-0.5*sigmayellow^-2*(mod(hART+180,360)-180)^2);
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

plotz = ((CIE_L/100)^pow)-Mrefcorr;
ring = ring100*relring;

out = di_joinchannels(in(1).color,'art',plotz,ring,hART);
