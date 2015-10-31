%dip_binarynoise   Generates an image disturbed by binary noise.
%    out = dip_binarynoise(in, p10, p01)
%
%   in
%      Image.
%   p10
%      Real number.
%   p01
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
%binary
%FUNCTION
%Generate an image disturbed by binary noise.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dip_float p10     double p10     Probability of a one to zero transition
%  dip_float p01     double p01     Probability of a one to zero transition
%  dip_Random *random            Pointer to a random value structure
%
%EXAMPLE
%Get a binary noise disturbed image as follows:
%
%   dip_Image in, out;
%   dip_float p10, p01;
%   dip_Random random;
%   p10 = 0.1;
%   p01 = 0.2;
%   DIPXX( dip_BinaryNoise(in, out, p10, p01, &random ));
%
%SEE ALSO
% RandomVariable , RandomSeed , UniformNoise , GaussianNoise , PoissonNoise , BinaryNoise
