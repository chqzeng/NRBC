%dip_gaussiannoise   Generate an image disturbed by Gaussian noise.
%    out = dip_gaussiannoise(in, variance)
%
%   in
%      Image.
%   variance
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
%Generate an image disturbed by additive Gaussian noise.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dip_float variance      double variance      Variance of the Gaussian distribution the noise is drawn from
%  dip_Random *random            Pointer to a random value structure
%
%EXAMPLE
%Get a image with additive Gaussian noise as follows:
%
%   dip_Image in, out;
%   dip_float variance;
%   dip_Random random;
%   variance = 1.0;
%   DIPXX(dip_GaussianNoise(in, out, variance, &random ));
%
%SEE ALSO
% RandomVariable , RandomSeed , UniformNoise , GaussianNoise , PoissonNoise , BinaryNoise
