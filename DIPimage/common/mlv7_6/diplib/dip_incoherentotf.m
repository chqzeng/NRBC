%dip_incoherentotf   Generates an incoherent OTF.
%    out = dip_incoherentotf(out, defocus, xNyquist, amplitude, otf)
%
%   out
%      Image.
%   defocus
%      Real number.
%   xNyquist
%      Real number.
%   amplitude
%      Real number.
%   otf
%      String containing one of the following values:
%      'stokseth', 'hopkins'.

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
%This function implements the formulae for a (defocused) incoherent OTF as
%described by Castleman. When defocus is unequal to zero, either the Stokseth
%approximation or the Hopkins approximation is used.
%The defocus is defined a the maximum defocus path length error divided by the
%wave length (See Castleman for details). The summation over the
%Bessel functions in the Hopkins formluation, is stopped when the change is
%smaller than DIP_MICROSCOPY_HOPKINS_OTF_CUTOFF.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image out     IMAGE *out     Output
%  dip_float defocus    double defocus    Defocus
%  dip_float xNyquist      double xNyquist      Oversampling
%  dip_float amplitude     double amplitude     Amplitude
%  dipf_IncoherentOTF otf     int otf     Otf approximation
%
%The dipf_IncoherentOTF enumeration supports the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_MICROSCOPY_OTF_STOKSETH      MPY_OTF_STOKSETH     Stokseth OTF approximation
%  DIP_MICROSCOPY_OTF_HOPKINS    MPY_OTF_HOPKINS      Hopkins OTF approximation
%
%LITERATURE
%K.R. Castleman, "Digital image processing, second edition",
%Prentice Hall, Englewood Cliffs, 1996.
%SEE ALSO
% IncoherentPSF
