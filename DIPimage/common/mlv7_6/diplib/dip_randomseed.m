%dip_randomseed   Random seed function.
%    dip_randomseed(seedval)
%
%   seedval
%      Unsigned integer.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   FUNCTION:
%Initializes a dip_Random structure with a given seed value.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Random *random            Pointer to a random value structure
%  dip_uint32 seedval            Seed value
%
%EXAMPLE
%Initialize a dip_Random structure as follows:
%
%   dip_Random random;
%   dip_uint32 seed;
%   seed = 123758;
%   DIPXX(dip_RandomSeed( &random, seed ));
%
%SEE ALSO
% RandomVariable , RandomSeed , UniformRandomVariable , GaussianRandomVariable , PoissonRandomVariable , BinaryRandomVari%able
