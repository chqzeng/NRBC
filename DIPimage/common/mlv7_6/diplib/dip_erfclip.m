%dip_erfclip   Point Operation.
%    out = dip_erfclip(in, threshold, range, clipFlag)
%
%   in
%      Image.
%   threshold
%      Real number.
%   range
%      Real number.
%   clipFlag
%      Clip flag. String containing one of the following values:
%      'low', 'high', 'both'.
%      'thresh/range' is the same as 'both'.
%      'low/high' specifies that threshold and range are really
%                 lower and upper bounds

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
%Clips in using the erf function at either
%the minimum value clipLow of the maximum value clipHigh
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float threshold     double threshold     Threshold value
%  dip_float range      double range      Range value
%  dipf_Clip clipFlag      int clipFlag      clipFlag
%
%
%The following dipf_Clip flags are defined:
%
%     DIP_CLIP_BOTH     clip both the lower and upper bound       DIP_CLIP_LOW      clip lower bound only         DIP_CLIP_HIGH     clip upper bound only         DIP_CLIP_LOW_AND_HIGH_BOUNDS     same as DIP_CLIP_BOTH
%The lower bound is defined by threshold - range/2 and upper bound by
%threshold + range/2.
%LITERATURE
%L.J. van Vliet, Grey-Scale Measurements in Multi-Dimensional Digitized Images, Ph.D. thesis Delft University of Technology, Delft University Press,
%Delft, 1993
%SEE ALSO
% Threshold , RangeThreshold , Clip , ContrastStretch
