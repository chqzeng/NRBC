%dip_vdt   Euclidean vector distance transform.
%    out = dip_vdt(in, distance, border, method)
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
%  This function produces the vector components of the euclidean distance transform
%   of an input binary image. Components are stored in the output images, one for each
%   dimension of the input image. See the EuclideanDistanceTransform for detailed
%   information about the functions parameters. To compute the euclidean distance
%   from the vector compoments produced by this function, one needs to multiply each
%   componemt with the sampling distance, square the result, sum the results for all
%   components and take the square root of the sum.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_ImageArray out      IMAGE *outx, outy, outz    Output images
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
%  See EuclideanDistanceTransform
%KNOWN BUGS
%  See EuclideanDistanceTransform
%AUTHOR
%   James C. Mullikin, adapted to DIPlib by Geert M.P. van Kempen
%SEE ALSO
%GreyWeightedDistanceTransform , EuclideanDistanceTransform
