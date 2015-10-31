%dip_crosscorrelationft   Estimate the shift between images.
%    out = dip_crosscorrelationft(in1, in2, in1rep, in2rep, outrep)
%
%   in1
%      Image.
%   in2
%      Image.
%   in1rep
%      Image representation. String containing one of the following values:
%      'spatial', 'spectral'.
%   in2rep
%      Image representation. String containing one of the following values:
%      'spatial', 'spectral'.
%   outrep
%      Image representation. String containing one of the following values:
%      'spatial', 'spectral'.

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
%This function calculates the cross-correlation between two images of equal size.
%The returned image is the cross-correlation normalized in such a way that only
%the phase information is of importance. This results as a very sharp peak
%in the spatial domain. This function performs
%out = (Conj(in1)*in2)/((Abs(in1))^2)
%
% in the Fourier domain. It is used by FindShift. The inrep, psfrep
%and outrep specify whether the images are spatial images
%(DIP_IMAGE_REPRESENTATION_SPATIAL) or their Fourier transform.
%(DIP_IMAGE_REPRESENTATION_SPECTRAL).
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in1     IMAGE *in1     Input image
%  dip_Image in2     IMAGE *in2     Input image
%  dip_Image out     IMAGE *out     Output image
%  dipf_ImageRepresentation in1rep     int in1rep     Input 1 spatial or spectral
%  dipf_ImageRepresentation in2rep     int in2rep     Input 2 spatial or spectral
%  dipf_ImageRepresentation outrep     int outrep     Output spatial or spectral
%
%SEE ALSO
% FindShift
