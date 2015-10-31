/*
 * Filename: dip_filtering.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIP_FILTERING_H
#define DIP_FILTERING_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_pixel_table.h"

DIP_ERROR dip_VarianceFilter( dip_Image, dip_Image, dip_Image,
      dip_BoundaryArray, dip_FloatArray, dip_FilterShape );

DIP_ERROR dip_Kuwahara( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
      dip_FloatArray, dip_FilterShape );

DIP_ERROR dip_GeneralisedKuwahara( dip_Image, dip_Image, dip_Image,
      dip_Image, dip_BoundaryArray, dip_FloatArray,
      dip_FilterShape, dip_Boolean );

DIP_ERROR dip_KuwaharaImproved( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
      dip_FloatArray, dip_FilterShape, dip_float );

DIP_ERROR dip_GeneralisedKuwaharaImproved( dip_Image, dip_Image, dip_Image,
      dip_Image, dip_BoundaryArray, dip_FloatArray,
      dip_FilterShape, dip_float, dip_Boolean );

DIP_ERROR dip_Sigma ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
         dip_FloatArray, dip_FilterShape, dip_float, dip_Boolean, dip_Boolean);

DIP_ERROR dip_BiasedSigma ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
         dip_FloatArray, dip_FilterShape, dip_float, dip_Boolean, dip_Boolean);

DIP_ERROR dip_GaussianSigma ( dip_Image, dip_Image, dip_BoundaryArray,
         dip_float, dip_FloatArray, dip_Boolean, dip_Boolean, dip_float);

DIP_ERROR dip_Maxima ( dip_Image, dip_Image, dip_Image, dip_int, dip_Boolean );
DIP_ERROR dip_Minima ( dip_Image, dip_Image, dip_Image, dip_int, dip_Boolean );

DIP_ERROR dip_NonMaximumSuppression ( dip_Image, dip_Image, dip_Image, dip_Image, dip_Image );

#ifdef __cplusplus
}
#endif
#endif
