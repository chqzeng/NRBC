%dip_incoherentpsf   Generates an incoherent PSF.
%    out = dip_incoherentpsf(out, xNyquist, amplitude)
%
%   out
%      Image.
%   xNyquist
%      Real number.
%   amplitude
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
%Output: sfloat
%FUNCTION
%This function generates an incoherent in-focus point spread function of
%a diffraction limited objective.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image output     IMAGE *output     Output Image
%  dip_float xNyquist      double xNyquist      Oversampling Factor
%  dip_float amplitude     double amplitude     Amplitude
%
%LITERATURE
%K.R. Castleman, "Digital image processing, second edition",
%Prentice Hall, Englewood Cliffs, 1996.
%SEE ALSO
% IncoherentOTF
