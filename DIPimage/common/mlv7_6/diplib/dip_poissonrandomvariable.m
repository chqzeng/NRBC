%dip_poissonrandomvariable   Poisson random variable generator.
%    out = dip_poissonrandomvariable(input)
%
%   input
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
%dip_PoissonRandomVariable uses the algorithm as described in
%"Numerical Recipes in C, 2nd edition", section 7.3.
%The define DIP_NOISE_POISSON_APPROXIMATE (default 30) in dip_noise.h
%determines the minimum value of the mean for which the rejection
%method is used. Setting this value higher will result in variables
%whose distribution is a slightly better approximation of the true
%Poisson distribution, but at the expense of a significantly higher
%computational effort.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Random *random            Pointer to a random value structure
%  dip_float input      double input      Input value
%  dip_float *output          Poisson distributed output value
%        int display    Display the return value
%
%EXAMPLE
%Get a Poisson random variable as follows:
%
%   dip_Random random;
%   dip_float mean, value;
%   mean = 23.0;
%   DIPXX( dip_PoissonRandomVariable( &random, mean, &value));
%
%LITERATURE
%Press, W.H., Teukolsky, S.A., Vetterling, W.T., and Flannery, B.P.
%Numerical Recipes in C, 2nd edition,
%Cambridge University Press, Cambridge, 1992.
%SEE ALSO
% RandomVariable , RandomSeed , UniformRandomVariable , GaussianRandomVariable , PoissonRandomVariable , BinaryRandomVari%able , UniformNoise , GaussianNoise , PoissonNoise , BinaryNoise
