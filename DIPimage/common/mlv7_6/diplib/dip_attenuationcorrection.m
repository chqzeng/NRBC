%dip_attenuationcorrection   Attenuation correction algorithm.
%    out = dip_attenuationcorrection(in, fAttenuation, bAttenuation,...
%          background, threshold, NA, refIndex, ratio, method)
%
%   in
%      Image.
%   fAttenuation
%      Real number.
%   bAttenuation
%      Real number.
%   background
%      Real number.
%   threshold
%      Real number.
%   NA
%      Real number.
%   refIndex
%      Real number.
%   ratio
%      Real number.
%   method
%      String containing one of the following values:
%      'lt2', 'lt1', 'det', 'default'.

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
%This function implements an attenuation correction using three different
%recursive attenuation correction algorithms. The RAC-DET algorithm is the most
%accurate one, since it takes both forward and backward attenuation into account.
%It is however considerably slower that the RAC-LT2 and RAC-LT1 algorithms which
%take only forward attenuation into account. These last two algorithms assume
%a constant attenuation (background) for pixels with an intensity
%lower than the threshold.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float fAttenuation     double fAttenuation     Forward attenuation factor
%  dip_float bAttenuation     double bAttenuation     Backward attenuation factor
%  dip_float background    double background    Background attenuation factor
%  dip_float threshold     double threshold     Background threshold
%  dip_float NA      double NA      Numerical aperture
%  dip_float refIndex      double refIndex      Refractive index
%  dip_float ratio      double ratio      Z/X sampling ratio
%  dipf_AttenuationCorrection method      int method     Correction method
%
%The dipf_AttenuationCorrection enumaration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_ATTENUATION_RAC_LT2    RAC-LT2     Recursive Attenuation Correction algorithm using two Light Cone convolutions
%  DIP_ATTENUATION_RAC_LT1    RAC-LT1     Recursive Attenuation Correction algorithm using one Light Cone convolution
%  DIP_ATTENUATION_RAC_DET    RAC-DET     Recursive Attenuation Correction algorithm using Directional Extinction Tracking
%
%LITERATURE
%K.C. Strasters, H.T.M. van der Voort, J.M. Geusebroek, and A.W.M. Smeulders,
%Fast attenuation correction in fluorescence confocal imaging:
%a recursive approach, BioImaging, vol. 2, no. 2, 1994, 78-92.
%AUTHOR
%Karel Strasters, adapted to DIPlib by Geert van Kempen.
%SEE ALSO
% SimulatedAttenuation , ExponentialFitCorrection
