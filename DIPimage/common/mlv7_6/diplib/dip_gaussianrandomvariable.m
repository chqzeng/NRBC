%dip_gaussianrandomvariable   Gaussian random variable generator.
%    [out1, out2] = dip_gaussianrandomvariable(mean, variance)
%
%   mean
%      Real number.
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

%   FUNCTION:
%dip_GaussianRandomVariable uses the algorithm, described by
%D.E. Knuth as the Polar Method,
%to generate two Gaussian distributed random variables.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Random *random            Pointer to a random value structure
%  dip_float mean    double mean    Mean of the distribution, the samples are drawn from
%  dip_float variance      double variance      Variance of the distribution, the samples are drawn from
%  dip_float *output1            First output value
%  dip_float *output2            Second output value
%        int display    Display the return value
%
%EXAMPLE
%Get two Gaussian random variable as follows:
%
%   dip_Random random;
%   dip_float mean, variance, value1, value2;
%   mean = 0.0;
%   variance = 1.0;
%   DIPXX(dip_GaussianRandomVariable( &random, mean, variance, &value1, &value2 ));
%
%NOTE
%The SCIL-Image interface function GaussianRandomVariable only returns
%the first output value.
%LITERATURE
%Knuth, D.E.,
%Seminumerical algorithms, The art of computer programming, vol. 2, second edition
%Addison-Wesley, Menlo Park, California, 1981.
%SEE ALSO
% RandomVariable , RandomSeed , UniformRandomVariable , GaussianRandomVariable , PoissonRandomVariable , BinaryRandomVari%able
