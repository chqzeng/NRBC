%dip_ftgaussian   Generates the Fourier transform of a Gaussian.
%    out = dip_ftgaussian(in,sigma, amplitude, cutoff)
%
%   in
%      Input image.
%   sigma
%      Real array.
%   amplitude
%      Real number.
%   cutoff
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
%Output: sfloat, scomplex
%FUNCTION
%Generates the Fourier transform of a Gaussian with sigma's sigma. (The
%Fourier transform of a Gaussian, is a Gaussian.)
%The cutoff variable can be used to avoid the calculation of the exponent of
%large negative values, which is can be very time consuming. Values below
%the cutoff are set to zero.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image output     IMAGE *output     Output Image
%  dip_FloatArray sigma    double sX, sY, sZ    Sigma of the Gaussian
%  dip_float volume     double volume     Total intensity of the Gaussian
%  dip_float cutoff (DIP_GENERATION_EXP_CUTOFF)    double cutoff     Cutoff value for the exponent
%
%NOTE
%The SCIL-Image interface function sets the value of cutoff to
%DIP_GENERATION_EXP_CUTOFF.
%SEE ALSO
% FTEllipsoid , FTSphere , FTBox , FTCube , FTCross
