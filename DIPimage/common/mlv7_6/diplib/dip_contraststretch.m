%dip_contraststretch   Point operation.
%    out = dip_contraststretch(in, lowerBound, upperBound, outMaximum,...
%          outMinimum, method, sigmoidSlope, sigmoidPoint, maxDecade)
%
%   in
%      Image.
%   lowerBound
%      Real number.
%   upperBound
%      Real number.
%   outMaximum
%      Real number.
%   outMinimum
%      Real number.
%   method
%      Method. String containing one of the following values:
%      'linear', 'slinear', 'logarithmic', 'slogarithmic', 'erf', 'decade',
%      'sigmoid', 'clip', '01', 'pi'.
%   sigmoidSlope
%      Real number.
%   sigmoidPoint
%      Real number.
%   maxDecade
%      Real number.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATA TYPES:
%integer, float
%FUNCTION
%ContrastStretch stretches the pixel values of the input image. Pixel values
%higher or equal to UpperBound are stretched to the OutMaximum value. A similar
%thing holds for LowerBound and OutMinimum. Method determines how pixel values
%are stretched. SigmoidSlope and SigmoidPoint are used by the DIP_CST_SIGMOID
%method. MaxDecade determines the maximum number of decades the method
%DIP_CST_DECADE will stretch (values lower than MaxDecade will be set to zero).
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dip_float lowerBound    double lowerBound    LowerBound (%)
%  dip_float upperBound    double upperBound    UpperBound (%)
%  dip_float outMax     double outMax     OutMaximum
%  dip_float outMin     double outMin     OutMinimum
%  dipf_ContrastStretch method      int method     Method
%  dip_float sigmoidSlope     double sigmoidSlope     SigmoidSlope
%  dip_float sigmoidPoint     double sigmoidPoint     SigmoidPoint
%  dip_float maxDecade     double maxDecade     MaxDecade
%
%
%The following dipf_ContrastStretch flags are defined:
%
%     DIP_CST_LINEAR     linear contrast stretch
%     DIP_CST_SIGNED_LINEAR       linear stretch with zero at fixed value
%     DIP_CST_LOGARITHMIC      logarithmic contrast stretch
%     DIP_CST_SIGNED_LOGARITHMIC    signed logarithmic contrast stretch
%     DIP_CST_ERF  linear contrast stretch with erf clipping
%     DIP_CST_DECADE    Decade contrast stretching
%     DIP_CST_SIGMOID      Contrast stretched by sigmoid function
%     DIP_CST_CLIP      Simple clipping
%     DIP_CST_01     Stretching of [0,1] input values
%     DIP_CST_PI    Stretching of [-Pi,Pi] input values
%
%In the explanaition of the different contrast stretch flags, the variables
%input, output, inMin, inMax, outMin and outMax are used. With
%input and output is meant the pixel being processed
%of respecitively the input and output image.
%inMin and inMax are the pixel values corresponding to
%the lowerBound and upperBound of the input image.
%outMin and outMax are parameters passed to the function dip_ContrastStretch.
%
%
%The DIP_CST_LINEAR stretches the input in the following way:
%
%  scale  = (outMax - outMin) / (inMax - inMin)
%  output = scale * (MIN(inMax, MAX(inMin, input )) - inMin) + outMin
%
%
%
%The DIP_CST_SIGNED_LINEAR stretches the input in the following way:
%
%  max    = MAX(inMax, ABS( inMin ));
%  scale  = (outMax - outMin) / (2 * max)
%  offset = (outMax - outMin)/ 2
%  output = scale * (MIN(inMax, MAX(inMin, input)) - offset) + outMin
%
%
%
%The DIP_CST_LOGARITHMIC stretches the input in the following way:
%
%   scale  = (outMax - outMin) / log( inMax - inMin + 1)
%   offset = inMin - 1
%   output = scale * log(MIN(inMax, MAX(inMin, input)) - offset) + outMin
%
%
%
%The DIP_CST_SIGNED_LOGARITHMIC stretches the input in the following way:
%
%   max    = MAX(inMax, ABS( inMin ))
%   scale  = (outMax - outMin) / (2 * log( max + 1))
%   offset = (outMax + outMin)/ 2
%   output = scale * log(MIN(inMax, MAX(inMin, input))- offset) + outMin
%
%
%
%The DIP_CST_ERF stretches the input in the following way:
%
%   scale     = (outMax - outMin) / (inMax - inMin)
%   threshold = (inMax + inMin)/ 2
%   range     = inMax - inMin
%   in        = MIN(inMax, MAX(inMin, input))
%   out       = (range / 2) * erf( SQRT_PI * (in - threshold) / range )
%   output    = scale * (out + threshold ) + outMin
%
%
%
%The DIP_CST_DECADE stretches the input in the following way:
%
%   inScale   = inMax - inMin
%   outScale  = outMax - outMin
%   in        = MIN(inMax, DIP_MAX(inMin, input))
%   decade    = log10(inScale / ( in - inMin + EPSILON))
%   if(decade e / ( in - inMin + EPSILON))
%      decade -= floor(decade)
%      output  = outScale * (1 - decade) + outMin
%   else
%      output  = 0
%
%
%
%The DIP_CST_SIGMOID stretches the input in the following way:
%
%   SIGMOID(x) = x / (1. + ABS(x))
%   min        = SIGMOID(sigmoidSlope * inMin + sigmoidPoint)
%   max        = SIGMOID(sigmoidSlope * inMax + sigmoidPoint)
%   scale      = (outMax - outMin) /(max - min)
%   in         = MIN(inMax, MAX(inMin, input))
%   output     = scale * (SIGMOID(slope * in + point) - min) + outMin
%
%
%
%The DIP_CST_CLIP stretches the input in the following way:
%
%   output = MIN(outMax, MAX(outMin, input))
%
%
%
%The DIP_CST_01 stretches the input in the following way:
%
%  scale  = (outMax - outMin)
%  output = scale * input + outMin
%
%
%
%The DIP_CST_01 stretches the input in the following way:
%
%  scale  = (outMax - outMin) / 2 * Pi
%  output = scale * (input + Pi) + outMin
%
%
%
%SEE ALSO
% this section in the FIP
%
% Threshold , RangeThreshold , Clip , ErfClip
