%dip_fouriertransform   Computes the Fourier transform.
%    out = dip_fouriertransform(in, trFlags, process)
%
%   in
%      Image.
%   trFlags
%      Direction of the transform. String containing one of the following values:
%      'forward', 'inverse'.
%   process
%      Boolean array.

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
%Performs a Fourier transform on in and places the result in out.
%
%
%Normalisation: 1/sqrt(dimension) for each dimension.
%
%
%Defaults: process may be zero, indicating that all dimensions should
%be processed.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dipf_FourierTransform trFlags    int trFlags    Transform flags
%  dip_BooleanArray process (0)     ../Text/DimensionToggle.html process      Dimensions to process
%  void *theFuture            For future use, should be set to zero
%
%The dipf_FourierTransform enumeration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_TR_FORWARD    TR_FORWARD     Forward transformation
%  DIP_TR_INVERSE    TR_INVERSE     Inverse transformation
%
%SEE ALSO
% HartleyTransform
