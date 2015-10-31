%dip_subsampling   Interpolation function.
%    out = dip_subsampling(in, sample)
%
%   in
%      Image.
%   sample
%      Integer array.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%binary, integer, float, complex
%FUNCTION
%This function subsamples in by copying each sampleth pixel to out.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_IntegerArray sample    IntegerArray sample     Sample distance
%
%SEE ALSO
% Resampling
