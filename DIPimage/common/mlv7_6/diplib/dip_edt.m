%dip_edt   Euclidean distance transform.
%    out = dip_edt(in, distance, border, method)
%
%   in
%      Image.
%   distance
%      Real array.
%   border
%      Boolean number (1 or 0).
%   method
%      Transform method. String containing one of the following values:
%      'fast', 'ties', 'true', 'bruteforce'.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-May 1999.

%   DATATYPES:
%binary
%FUNCTION
%  This function computes the euclidean distance transform of an input binary image using the
%  vector based method as opposed to the champher method. This method
%  computes distances from the objects (binary 1's) to the nearest background (binary 0's)
%  of in and stored the result in out.  The out image is a sfloat type image.
%
%  The distance parameter can be used to specify anisotropic sampling densities.
%   If it is set to zero, the sampling density is assumed to be 1.0 along all axes.
%
%  The border parameter specifies whether the edge of the image should be treated
%   as objects (border = DIP_TRUE) or as background (border = DIP_FALSE).
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image out     IMAGE *out     Output image
%  dip_FloatArray distance    double dx, dy, dz    Sampling distances
%  dip_Boolean border      int border     Image border type
%  dipf_DistanceTransform method    int method     Transform method
%
%  dipf_DistanceTransform defines the following distance transform types:
%
%  DIPlib      Scil-Image     Description    DIP_EDT_FAST      EDT_FAST    fastest, but most errors
%  DIP_EDT_TIES      EDT_TIES    slower, but fewer errors
%  DIP_EDT_TRUE      EDT_TRUE    slow, uses lots of memory, but is "error free"
%  DIP_EDT_BRUTE_FORCE     EDT_BRUTE_FORCE      gives a result from which errors are
%                                            calculated for the other methods.
%                                            This method is extremly slow and should
%                                            only be used for testing purposes.
%
%LITERATURE
%Danielsson, P.E. (1980). "Euclidean distance mapping." Computer Graphics and Image Processing 14: 227-248.
%
%Mullikin, J.C. (1992). "The vector distance transform in two and three dimensions." CVGIP: Graphical Models and Image Processing 54(6): 526-535.
%
%Ragnemalm, I. (1990). Generation of Euclidean Distance Maps, Thesis No. 206. Licentiate thesis. Linkoing University, Sweden.
%
%Ye, Q.Z. (1988). "The signed Euclidean distance transform and its applications." in Proceedings, 9th International Conference on Pattern Recognition, Rome, 495-499.
%
%KNOWN BUGS
%  The EDT_TRUE transform type is prone to produce an internal buffer overflow when
%   applied to larger (almost) spherical objects. It this cases use EDT_TIES or EDT_BRUTE_FORCE
%   instead. The option border = DIP_FALSE is not supported for EDT_BRUTE_FORCE. This function supports images with a dimensionality up to three.
%AUTHOR
%   James C. Mullikin, adapted to DIPlib by Geert M.P. van Kempen
%SEE ALSO
%GreyWeightedDistanceTransform , VectorDistanceTransform
