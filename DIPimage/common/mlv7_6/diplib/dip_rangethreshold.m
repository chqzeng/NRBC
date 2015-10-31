%dip_rangethreshold   Point Operation.
%    out = dip_rangethreshold(in, lowerBound, upperBound, foreground,...
%          background, binaryOutput)
%
%   in
%      Image.
%   lowerBound
%      Real number.
%   upperBound
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
%out = ( lowerBound &lt;= in &lt;= upperBound ? foreground : background)
%If the boolean binaryOutput is true, RangeThreshold
%will produce a binary image. Otherwise an
%image of the same type as the input image is produced, with the pixels set
%to either foreground or background.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_float lowerBound    double lowerBound    Lower bound
%  dip_float upperBound    double upperBound    Upper bound
%  dip_float foreground    double foreground    Foreground value
%  dip_float background    double background    Background value
%  dip_Boolean binaryOutput            Convert output image to binary
%
%SEE ALSO
% Threshold , Clip , ErfClip , ContrastStretch
