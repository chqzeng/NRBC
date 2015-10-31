%dip_gdt   Grey weighted distance transform.
%    [out,distance] = dip_gdt(in, seed, chamfer, customNeighborhood, customMetric)
%
%   in
%      Image.
%   seed
%      Image.
%   chamfer
%      Integer number (0, 3 or 5).
%   customNeighborhood
%      Integer array (ignored if chamfer is not 0).
%   customMetric
%      Real array (ignored if chamfer is not 0).
%
%   distance
%      Image. Optional output argument.

% (C) Copyright 1999-2000               Pattern Recognition Group
%     All rights reserved               Faculty of Applied Physics
%                                       Delft University of Technology
%                                       Lorentzweg 1
%                                       2628 CJ Delft
%                                       The Netherlands
%
% Cris Luengo, February-September 1999.

%   DATATYPES:
%binary
%FUNCTION
%     GreyWeightedDistanceTransform  determines  the  grey   weighted   distance
%     transform  of the object elements in the in image and
%     returns  the  result  in  the  out  image. The implemented
%     algorithm uses a heap sort for sorting the pixels to be
%     processed.
%
%     The images in and seed must have the same dimensions. The out
%     image will be converted to a sfloat typed image.
%     The seed image defines the elements that are part of the object
%     for which the GDT is determined. It can by any type of image
%     where all image elements not equal to 0 are considered to be
%     part  of the object(s).  Those elements that are neighboring
%     an object element in the output image are considered  seeds.
%     Before  any  seeds are detected the borders of the Out image
%     are set to 0. The size of the border is  determined  by  the
%     chamfer metric size (see below). In case of a 3 by 3 chamfer
%     metric the image border is one element, in case of a 5 by  5
%     chamfer  it  is  2  elements. Elements in the border are not
%     considered seeds. If no valid seeds are  found  the  routine
%     will terminate with an Illegal value error code.
%
%
%     The chamfer metric is defined by two  parameters:  neighborhood
%     and  metric.
%     neigborhood should supply the different  relative  addresses
%     of the neighboring elements according to the chamfer metric.
%     The first element neighborhood[0]  contains  the  number  of
%     elements  in  the  chamfer neighborhood. The next three elements
%     contain the  maximum  number  of  elements  a  chamfer
%     metric exceeds the central element. The rest of the elements
%     (starting from the fifth element) contain addresses  of  the
%     different  chamfer elements relative to the central element.
%     The metric array contains the corresponding  chamfer  metric
%     value.   An  example  of  a  3x3 neighborhood array with the
%     corresponding metric is:
%
%          neighborhood[0] = 8 (number of elements)
%          neighborhood[1] = 1 (x-border size)
%          neighborhood[2] = 1 (y-border size)
%          neighborhood[3] = 0 (z-border size)
%          neighborhood[4] = -imagewidth - 1,    metric[0] = 7
%          neighborhood[5] = -imagewidth,        metric[1] = 5
%          neighborhood[6] = -imagewidth + 1,    metric[2] = 7
%          neighborhood[7] = -1,                 metric[3] = 5
%          neighborhood[8] = 1,                  metric[4] = 5
%          neighborhood[9] = imagewidth - 1,     metric[5] = 7
%          neighborhood[10] = imagewidth,        metric[6] = 5
%          neighborhood[11] = imagewidth + 1,    metric[7] = 7
%
%     where imagewidth represents the width of the image in  image
%     pixels.
%     If both neighborhood  and  metric  pointers  are  NULL,  the
%     chamfer variable can be set to either 3 (indicating a 3x3 or
%     3x3x3 chamfer) or 5 in which case preset  neighborhood
%     and metric arrays will be used.
%ARGUMENTS
%
%  DIPlib      SCIL-Image     Description
%  dip_Image in      IMAGE *in      Input image
%  dip_Image seed    IMAGE *seed    Seed image
%  dip_Image out     IMAGE *out     Output image
%  dip_int chamfer      int chamfer    Chamfer
%  dip_IntegerArray neighborhood          Neighborhood
%  dip_FloatArray metric            Metric
%
%LITERATURE
%     "An efficient uniform cost  algorithm  applied  to  distance
%     transforms",  B.J.H.  Verwer, P.W. Verbeek, and S.T. Dekker,
%     IEEE Transactions on Pattern Analysis and  Machine  Intelli-
%     gence, vol. 11, no. 4, 1989, 425-429.
%
%     "Shading from shape, the eikonal equation  solved  by  grey-
%     weighted   distance  transform",  P.W.  Verbeek  and  B.J.H.
%     Verwer, Pattern Recognition Letters, vol. 11, no. 10,  1990,
%     681-690.
%
%     "Local distances for distance  transformations  in  two  and
%     three   dimensions",   B.J.H.  Verwer,  Pattern  Recognition
%     Letters, vol. 12, no. 11, 1991, 671-682.
%
%     "Distance  Transforms,  Metrics,  Algorithms,  and  Applica-
%     tions",  B.J.H.  Verwer,  Ph.D.  thesis  Delft University of
%     Technology, Delft University Press, Delft, 1991.
%
%     "3-D Texture characterized  by  Accessibility  measurements,
%     based  on the grey weighted distance transform", K.C. Stras-
%     ters, A.W.M. Smeulders, and H.T.M. van der  Voort,  BioImag-
%     ing, vol 2, no. 1, 1994, p. 1-21.
%
%     "Quantitative Analysis in Confocal Image  Cytometry",  Karel
%     C.  Strasters,  Delft  University  Press, Delft, 1994.  ISBN
%     90-407-1038-4, NUGI 841
%
%KNOWN BUGS
%  GreyWeightedDistanceTransform will not work on images that do not have a normal stride, nor on images with a dimensionality larger than three.
%AUTHOR
%  Karel C. Strasters, adapted to DIPlib by Geert M.P. van Kempen
%SEE ALSO
%EuclideanDistanceTransform , VectorDistanceTransform
