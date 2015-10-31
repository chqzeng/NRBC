%dip_ftcross   Generates the Fourier transform of a cross.
%    out = dip_ftcross(length, scale, amplitude)
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
%Generates the Fourier transform of a cross with the length of its sides
%specified by length and radius.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image image      IMAGE *image      Output Image
%  dip_float length     double length     Length of the cross' axes
%  dip_FloatArray scale    double sX, sY, sZ    Scale
%  dip_float amplitude     double amplitude     Amplitude
%
%SEE ALSO
% FTEllipsoid , FTSphere , FTBox , FTCube , FTGaussian
