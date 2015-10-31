%dip_clip   Point operation.
%    out = dip_clip(in, clipLow, clipHigh, clipFlag)
%
%   in
%      Image.
%   clipLow
%      Real number.
%   clipHigh
%      Real number.
%   clipFlag
%      Clip flag. String containing one of the following values:
%      'low', 'high', 'both'.
%      'low/high' is the same as 'both'.
%      'thresh/range' specifies that clipLow and clipHigh are really
%                     threshold and range values.

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
%Clips in at either the minimum value clipLow of the maximum value clipHigh
%or both. If the flag DIP_CLIP_THRESHOLD_AND_RANGE is specified, the clip
%bound are defined by clipLow +/- clipHigh/2.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float clipLow    double clipLow    Lower clip bound value
%  dip_float clipHigh      double clipHigh      Higher clip bound value
%  dipf_Clip clipFlag      int clipFlag      Clip flag
%
%
%The following dipf_Clip flags are defined:
%
%     DIP_CLIP_BOTH     clip both the lower and upper bound
%     DIP_CLIP_LOW      clip lower bound only
%     DIP_CLIP_HIGH     clip upper bound only
%     DIP_CLIP_THRESHOLD_AND_RANGE     use clipLow and clipHigh as threshold and range value
%     DIP_CLIP_LOW_AND_HIGH_BOUNDS     same as DIP_CLIP_BOTH
%
%SEE ALSO
% Threshold , RangeThreshold , ErfClip , ContrastStretch
