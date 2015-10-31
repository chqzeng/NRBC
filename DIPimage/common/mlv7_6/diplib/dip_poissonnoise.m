%dip_poissonnoise   Generate an image disturbed by Poisson noise.
%    out = dip_poissonnoise(in, conversion)
%
%   in
%      Image.
%   conversion
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
%Generate a Poisson noise disturbed image. The intensities of the input image
%divided by the conversion variable are used as mean value for the
%Poisson distribution. The conversion factor can be used to relate the
%pixel values with the number of counts. For example, the simulate a
%photon limited image acquired by a CCD camera, the conversion factor
%specifies the relation between the number of photons recorded and the
%pixel value it is represented by.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dip_float conversion    double conversion    Conversion factor (photon/ADU)
%  dip_Random *random            random
%
%EXAMPLE
%Get a Poisson disturbed image as follows:
%
%   dip_Image in, out;
%   dip_float conversion;
%   dip_Random random;
%   conversion = 2.0;
%   DIPXX( dip_PoissonNoise(in, out, conversion, &random ));
%
%SEE ALSO
% RandomVariable , RandomSeed , UniformRandomVariable , GaussianRandomVariable , PoissonRandomVariable , BinaryRandomVari%able , UniformNoise , GaussianNoise , PoissonNoise , BinaryNoise
