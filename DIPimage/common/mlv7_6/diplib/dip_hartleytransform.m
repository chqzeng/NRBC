%dip_hartleytransform   Computes the Hartley transform.
%    out = dip_hartleytransform(in, trFlags, process)
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
%binary, integer, float
%FUNCTION
%This function computes a Hartley transform on in and places the result
%in out.
%
%
%Normalisation: 1/sqrt(dimension) for each dimension.
%
%
%The main advantage of the Hartley transform over the Fourier transform is that
%is requires half the storage for real valued images. Note, that is also
%possible to directly reduce the storage requirements of the Fourier
%transform by just storing the right half plane, since for real valued images
%the left half plane can be derived from the right half using the
%symmetry properties of the Fourier transform.
%
%
%Unfortunately there seem to be two definitions of the multi-dimensional Hartley
%transform (they are identical in the 1-D case). DIPlib implements the Bracewell
%(see below) variant, since this one is easy to implement and inherits the
%storage advantage from the 1-D case. The following are references which
%each use a different variant (all scaling factors have been dropped):
%
%
%Bracewell, "Discrete Hartley Transform", J. Opt. Soc. Am, vol. 73, no. 12,
%December 1983 :
%
%DHT(u,v) = Sum Sum I(x,y) cas( ux ) cas( vy )
%            y   x
%
%Kenneth R. Castleman, "Digital image processing", Prentice Hall, 1996 :
%
%DHT(u,v) = Sum Sum I(x,y) cas( ux + vy )
%            y   x
%
%Using cas(a) = cos(a) + sin(a) :
%
%cas(ux)cas(vy) = cos(ux)cos(vy)+cos(ux)sin(vy)+sin(ux)cos(vy)+sin(ux)sin(vy)
%cas(ux+vy)     = cos(ux)cos(vy)+cos(ux)sin(vy)+sin(ux)cos(vy)-sin(ux)sin(vy)
%                                                            ^^^
%
%A subtle difference. The two definitions have very similar properties,
%for example the convolution property.
%
%
%In implementation terms, Bracewell is equivalent to perform the one-dimensional
%Hartley transform along each dimension. The Castleman variant is equivalent
%to the definition: DHT = re(DFT) - im(DFT). On a final note, I've not
%noticed mention of the difference between the two variants, so the indications
%Bracewell's and Castleman's variant are not and should not be accepted
%"labels" to refer to the variants (For both variants I have selected the
%first reference I came across, not chronologically the first reference
%to use the variant).
%
%
%Defaults: process may be zero, indicating that all dimensions should
%be processed.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input
%  dip_Image out     IMAGE *out     Output
%  dipf_FourierTransform trFlags    int trFlags    Transformation flags
%  dip_BooleanArray process (0)      process    Dimensions to process
%
%The dipf_FourierTransform enumeration consists of the following flags:
%
%  DIPlib      Scil-Image     Description    DIP_TR_FORWARD    TR_FORWARD     Forward transformation
%  DIP_TR_INVERSE    TR_INVERSE     Inverse transformation
%
%SEE ALSO
% FourierTransform
