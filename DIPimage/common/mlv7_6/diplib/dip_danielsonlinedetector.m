%dip_danielsonlinedetector   Line detector.
%    [line, energy, angle] = dip_danielsonlinedetector(in, sigma, flavour)
%
%   in
%      Input image.
%   line
%      Line image.
%   energy
%      Energy image.
%   angle
%      Angle image.
%   sigma
%      Real array.
%   flavour
%      Derivative flavour. String containing one of the following values:
%      'gaussiir', 'gaussfir', 'gaussft', 'finitediff'.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-July 1999.

%   DATATYPES:
%binary, integer, float
%FUNCTION
%The Danielson line dectector uses second derivatives to detect lines in 2D
%images and to estimate their orientation. See the literature reference for an in-depth information on this
%detector.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image line    IMAGE *line    Line image
%  dip_Image energy     IMAGE *energy     Energy image
%  dip_Image angle      IMAGE *angle      Angle image
%  dip_BoundaryArray boundary    BoundaryArray boundary     Boundary Conditions
%  dip_FloatArray sigma    double sigmaX, sigmaY      Sigma of second derivatives
%  dip_float truncation    double truncation    Gauss Truncation
%  dip_DerivativeFlavour flavour    DerivativeFlavour flavour     Gauss filter flavour
%
%LITERATURE
%P.E. Danielson, Q. Lin and Q-Z Yes, i"Efficient detection of second degree
%variations in 2D and 3D images", Report LiTH-ISY-R-2155, Linkoping University,
%Linkoping, Sweden, 1999
%SEE ALSO
% Derivative , StructureTensor2D
