%dip_shift   an image manipulation function.
%    out = dip_shift(in, shift, killNy)
%
%   in
%      Image.
%   shift
%      Real array.
%   killNy
%      Boolean

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
%This function is a frontend to FTShift. It performs:
%
%out = Real(InverseFourierTransform(FTShift(shift) * FourierTransform( in ))
%
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_FloatArray shift    FloatArray shift     Shift array
%
%SEE ALSO
% FTShift , FourierTransform , Real
