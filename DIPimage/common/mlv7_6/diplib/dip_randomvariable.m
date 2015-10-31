%dip_randomvariable   Random number generator.
%    out = dip_randomvariable

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   FUNCTION:
%Generates a random number between zero and one.
%
%This function is based on the Numerical Recipes' RAN0 function. The dip_Random
%structure can be initialized with the function dip_RandomSeed. If the supplied
%dip_Random structure is not initialized, dip_RandomVariable will initialize
%the dip_Random structure with a seed equal to zero. To guarantee the (psuedo)
%randomness between variables obtained with subsequent calls to
%dip_RandomVariable (or to functions that use this function to obtain a random
%variable), a pointer to the same dip_Random structure has to supplied when
%calling dip_RandomVariable.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Random *random            Pointer to a random value structure
%  dip_float *value           value
%        int display    Display the return value
%
%EXAMPLE
%Obtain a random number as follows:
%
%   dip_Random random;
%   dip_float val;
%   DIPXX(dip_RandomVariable( &random, &val));
%
%NOTE
%The SCIL-Image interface function RandomVariable obtains a pointer to a
%random value structure, by calling GlobalGetRandomGenerator.
%This function gives a pointer to a globally defined random structure.
%SEE ALSO
% RandomVariable , RandomSeed , UniformRandomVariable , GaussianRandomVariable , PoissonRandomVariable , BinaryRandomVari%able
