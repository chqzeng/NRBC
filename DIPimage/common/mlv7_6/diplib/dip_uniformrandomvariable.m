%dip_uniformrandomvariable   Uniform random variable generator.
%    out = dip_uniformrandomvariable(lowerBound, upperBound)
%
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

%   FUNCTION:
%Generate an uniform distributed random variable.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Random *random            Pointer to a random value structure
%  dip_float lowerBound    double lowerBound    Lower bound of the uniform distribution the variable is drawn from
%  dip_float upperBound    double upperBound    Upper bound of the uniform distribution the variable is drawn from
%  dip_float *output          output
%        int display    Display the return value
%
%EXAMPLE
%Get a uniform random variable as follows:
%
%   dip_Random random;
%   dip_float lower, upper, value;
%   lower = -1.0;
%   upper = 1.0;
%   DIPXX( dip_UniformRandomVariable( &random, lower, upper,  &value));
%
%SEE ALSO
% RandomVariable , RandomSeed , UniformRandomVariable , GaussianRandomVariable , PoissonRandomVariable , BinaryRandomVari%able
