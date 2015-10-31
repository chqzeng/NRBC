%dip_exponentialfitcorrection   Exponential fit based attenuation correction.
%    out = dip_exponentialfitcorrection(in, method, percentile,...
%          fromWhere, hysteresis, varWeighted)
%
%   in
%      Image.
%   method
%      String containing one of the following values:
%      'default', 'mean', 'percentile'.
%   percentile
%      Real number.
%   fromWhere
%      String containing one of the following values:
%      'default', 'firstpixel', 'globalmax', 'firstmax'.
%   hysteresis
%      Real number.
%   varWeighted
%      Boolean number (1 or 0).

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   FUNCTION:
%This routine implements a simple absorption, reflection and bleaching
%correction based upon the assumption that the sum of these effects result
%in a exponential extinction of the signal as a function of depth. Only
%pixels that are non-zero are taken into account.
%Depending upon the chosen method, the mean or a percentile of all the non-zero
%pixels are calculated as a function of the slice number (depth).
%Then an exponential function is fitted
%through these slice-representing values. The starting point of the fit is
%determined by fromWhere. The first maximum is found with
%point[z+1] &gt; hysteresis * point[z].
%If the mean variant is chosen one can chose to apply a variance weighting
%to the fit.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dipf_ExpFitData method     int method     Data statistic to fit on
%  dip_float percentile    double percentile    Percentile
%  dipf_ExpFitStart fromWhere    int fromWhere     From where to start the fit
%  dip_float hysteresis    double hysteresis    First maximum hysteresis
%  dip_Boolean varWeighted    int varWeighted      Fit with variance weights
%
%The dipf_ExpFitData enumaration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_ATTENUATION_EXP_FIT_DATA_MEAN      MEAN     Fit on the mean values
%  DIP_ATTENUATION_EXP_FIT_DATA_PERCENTILE      PERCENTILE     Fit on the specified percentile of the data
%
%The dipf_ExpFitStart enumaration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_ATTENUATION_EXP_FIT_START_FIRST_PIXEL    FIRST_PIXEL    Start fit on first pixel
%  DIP_ATTENUATION_EXP_FIT_START_GLOBAL_MAXIMUM    GLOBAL_MAXIMUM    Start fit on global maximum
%  DIP_ATTENUATION_EXP_FIT_START_FIRST_MAXIMUM     FIRST_MAXIMUM     Start fit on first maximum
%
%LITERATURE
%K.C. Strasters, H.T.M. van der Voort, J.M. Geusebroek, and A.W.M. Smeulders,
%"Fast attenuation correction in fluorescence confocal imaging:
%a recursive approach", BioImaging, vol. 2, no. 2, 1994, 78-92.
%AUTHOR
%Karel Strasters, adapted to DIPlib by Geert van Kempen.
%SEE ALSO
% AttenuationCorrection , SimulatedAttenuation
