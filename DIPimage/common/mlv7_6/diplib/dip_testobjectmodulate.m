%dip_testobjectmodulate   TestObject generation function.
%    out = dip_testobjectmodulate(in, modulation, modulationDepth)
%
%   in
%      Image.
%   modulation
%      Real array.
%   modulationDepth
%      Real number.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%Output: sfloat
%FUNCTION
%This function adds a sine modulation to a test object, with modulation the
%modulation frequency and modulationDepth the modulation depth.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dip_FloatArray modulation     double mx, my, mz    Modulation Frequency
%  dip_float modulationDepth     double modulationDepth     ModulationDepth
%
%SEE ALSO
% TestObjectCreate , TestObjectBlur , TestObjectAddNoise
