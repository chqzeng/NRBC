%dip_ftellipsoid   Generates Fourier transform of a ellipsoid.
%    out = dip_ftellipsoid(radius, inScale, amplitude)
%
%   radius
%      Real number.
%   inScale
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
%Generates the Fourier transform of an ellipsoid with the length of its
%axes specified by radius and scale.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image image      IMAGE *image      Output Image
%  dip_float radius     double radius     Radius
%  dip_FloatArray scale    double sX, sY, sZ    Scale
%  dip_float amplitude     double amplitude     Amplitude
%
%LITERATURE
%L.J. van Vliet, Grey-Scale Measurements in Multi-Dimensional Digitized Images, Ph.D. thesis Delft University of Technology, Delft University Press,
%Delft, 1993
%KNOWN BUGS
%This function is only implemented for images with a dimensionality up to three.
%SEE ALSO
% FTSphere , FTBox , FTCube , FTCross , FTGaussian
