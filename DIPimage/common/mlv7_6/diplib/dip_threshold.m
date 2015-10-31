%dip_threshold   Point Operation.
%    out = dip_threshold(in, threshold, foreground, background, binaryOutput)
%
%   in
%      Image.
%   threshold
%      Real number.
%   foreground
%      Real number.
%   background
%      Real number.
%   binaryOutput
%      Boolean number (1 or 0).

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
%This function thresholds an image at the threshold value. If the boolean
%binaryOutput is true, Threshold will produce a binary image. Otherwise an
%image of the same type as the input image is produced, with the pixels set
%to either foreground or background. In other words:
%out = ( in &gt;= # threshold ? foreground : background)
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float threshold     double threshold     Threshold value
%  dip_float foreground    double foreground    Foreground value
%  dip_float background    double background    Background value
%  dip_Boolean binaryOutput            Convert output image to binary
%
%SEE ALSO
%this section in the FIP
%
% Threshold , RangeThreshold , Clip , ErfClip , ContrastStretch
