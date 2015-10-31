%dip_convolveft   Fourier transform based Convolution filter.
%    out = dip_convolveft(in, psf, inrep, psfrep, outrep)
%
%   in
%      Image.
%   psf
%      Image.
%   inrep
%      Image representation. String containing one of the following values:
%      'spatial', 'spectral'.
%   psfrep
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
%This function convolves the input image with the point spread function psf,
%by multiplying their Fourier transforms. The inrep, psfrep and outrep
%specify whether the images are spatial images
%(DIP_IMAGE_REPRESENTATION_SPATIAL) or their Fourier transform.
%(DIP_IMAGE_REPRESENTATION_SPECTRAL).
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image psf     IMAGE *psf     Psf image
%  dip_Image out     IMAGE *out     Output image
%  dipf_ImageRepresentation inrep      int inrep      Input spatial or spectral
%  dipf_ImageRepresentation psfrep     int psfrep     PSF spatial or spectral
%  dipf_ImageRepresentation outrep     int outrep     Output spatial or spectral
%
%SEE ALSO
%../Text/Convolution.html
%
