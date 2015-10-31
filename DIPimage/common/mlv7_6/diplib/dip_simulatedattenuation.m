%dip_simulatedattenuation   Simulation of the attenuation process.
%    out = dip_simulatedattenuation(in, fAttenuation, bAttenuation,...
%          NA, refIndex, zxratio, oversample, rayStep)
%
%   in
%      Image.
%   fAttenuation
%      Real number.
%   bAttenuation
%      Real number.
%   NA
%      Real number.
%   refIndex
%      Real number.
%   zxratio
%      Real number.
%   oversample
%      Integer number.
%   rayStep
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
%binary, integer, float
%FUNCTION
%This function simulates an attenuation based on the model of a CSLM,
%using a ray tracing method.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float fAttenuation     double fAttenuation     Forward attenuation factor
%  dip_float bAttenuation     double bAttenuation     Backward attenuation factor
%  dip_float NA      double NA      Numerical aperture
%  dip_float refIndex      double refIndex      Refractive index
%  dip_float zxratio    double zxratio    Z/X sampling ratio
%  dip_int oversample      int oversample    Ray casting oversampling
%  dip_float rayStep    double rayStep    Ray step
%
%LITERATURE
%K.C. Strasters, H.T.M. van der Voort, J.M. Geusebroek, and A.W.M. Smeulders,
%Fast attenuation correction in fluorescence confocal imaging:
%a recursive approach, BioImaging, vol. 2, no. 2, 1994, 78-92.
%AUTHOR
%Karel Strasters, adapted to DIPlib by Geert van Kempen.
%SEE ALSO
% AttenuationCorrection , ExponentialFitCorrection
