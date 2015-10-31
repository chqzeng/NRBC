%dip_uniformnoise   Generate an image disturbed by uniform noise.
%    out = dip_uniformnoise(in, lowerBound, upperBound)
%
%   in
%      Image.
%   lowerBound
%      Real number.
%   upperBound
%      Real number.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATA TYPES:
%integer, float
%FUNCTION
%Generate an image disturbed by additive uniform noise.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dip_float lowerBound    double lowerBound    Lower bound of the uniform distribution the noise is drawn from
%  dip_float upperBound    double upperBound    Upper bound of the uniform distribution the noise is drawn from
%  dip_Random *random            Pointer to a random value structure
%
%EXAMPLE
%Get a image with additive uniform noise as follows:
%
%   dip_Image in, out;
%   dip_float lower, upper;
%   dip_Random random;
%   lower = 1.0;
%   upper = 10.0;
%   DIPXX(dip_UniformNoise(in, out, lower, upper, &random ));
%
%SEE ALSO
% RandomVariable , RandomSeed , UniformNoise , GaussianNoise , PoissonNoise , BinaryNoise
