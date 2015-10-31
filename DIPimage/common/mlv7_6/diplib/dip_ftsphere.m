%dip_ftsphere   Generated Fourier transform of a sphere.
%    out = dip_ftsphere(radius, amplitude)
%
%   radius
%      Real number.
%   amplitude
%      Real number.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%Output: sfloat, scomplex
%FUNCTION
%Generates the Fourier transform of a sphere with radius radius and an
%amplitude of amplitude.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image image      IMAGE *image      Output Image
%  dip_float radius     double radius     Radius
%  dip_float amplitude     double amplitude     Amplitude
%
%KNOWN BUGS
%This function is only implemented for images with a dimensionality up to three.
%SEE ALSO
% FTEllipsoid , FTBox , FTCube , FTCross , FTGaussian
