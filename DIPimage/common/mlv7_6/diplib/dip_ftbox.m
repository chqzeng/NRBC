%dip_ftbox   Generates the Fourier transform of a box.
%    out = dip_ftbox(length, scale, amplitude)
%
%   length
%      Real number.
%   scale
%      Real array.
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
%Generates the Fourier transform of a box with the half length of its sides
%specified by length and scale.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image image      IMAGE *image      Output Image
%  dip_float length     double length     Length
%  dip_FloatArray scale    double sX, sY, sZ    Scale
%  dip_float amplitude     double amplitude     Amplitude
%
%SEE ALSO
% FTEllipsoid , FTSphere , FTCube , FTCross , FTGaussian
