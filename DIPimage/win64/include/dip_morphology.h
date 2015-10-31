/*
 *
 * (C) Copyright 1995-2005               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 * Author: Geert M.P. van Kempen
 *
 */

#ifndef DIP_MORPHOLOGY_H
#define DIP_MORPHOLOGY_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_pixel_table.h"

typedef enum
{
   DIP_MPH_TEXTURE = 1,
   DIP_MPH_OBJECT  = 2,
   DIP_MPH_BOTH    = 3,
   DIP_MPH_DYNAMIC = 3
} dip_MphEdgeType;

typedef enum
{
   DIP_MPH_BLACK = 1,
   DIP_MPH_WHITE = 2
} dip_MphTophatPolarity;

typedef enum
{
   DIP_MPH_OPEN_CLOSE = 1,
   DIP_MPH_CLOSE_OPEN = 2,
   DIP_MPH_AVERAGE    = 3
} dipf_MphSmoothing;

typedef enum
{
   DIP_LEE_UNSIGNED = 1,
   DIP_LEE_SIGNED   = 2
} dipf_LeeSign;

#ifndef SWIG

/* declaration of morphological filter functions */
DIP_ERROR dip_Dilation        ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape );
DIP_ERROR dip_Erosion         ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape );
DIP_ERROR dip_Closing         ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape );
DIP_ERROR dip_Opening         ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape );

DIP_ERROR dip_Tophat          ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape, dip_MphEdgeType,
                                dip_MphTophatPolarity );
DIP_ERROR dip_MorphologicalThreshold
                              ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape, dip_MphEdgeType );
DIP_ERROR dip_MorphologicalGist
                              ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape, dip_MphEdgeType );
DIP_ERROR dip_MorphologicalRange
                              ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape, dip_MphEdgeType );
DIP_ERROR dip_MorphologicalGradientMagnitude
                              ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape, dip_MphEdgeType );
DIP_ERROR dip_Lee             ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape, dip_MphEdgeType,
                                dipf_LeeSign );
DIP_ERROR dip_MorphologicalSmoothing
                              ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape, dipf_MphSmoothing );
DIP_ERROR dip_MultiScaleMorphologicalGradient
                              ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_int, dip_int, dip_FilterShape );

DIP_ERROR dip_MorphologicalLaplace
                              ( dip_Image, dip_Image, dip_Image, dip_BoundaryArray,
                                dip_FloatArray, dip_FilterShape );

DIP_ERROR dip_Watershed       ( dip_Image, dip_Image, dip_Image, dip_int, dip_float,
                                dip_int, dip_Boolean );
DIP_ERROR dip_LocalMinima     ( dip_Image, dip_Image, dip_Image, dip_int, dip_float,
                                dip_int, dip_Boolean );
DIP_ERROR dip_UpperEnvelope   ( dip_Image, dip_Image, dip_Image, dip_Image, dip_int,
                                dip_float, dip_int );
DIP_ERROR dip_SeededWatershed ( dip_Image, dip_Image, dip_Image, dip_Image, dip_int,
                                dipf_GreyValueSortOrder, dip_float, dip_int, dip_Boolean );

DIP_ERROR dip_MorphologicalReconstruction
                              ( dip_Image, dip_Image, dip_Image, dip_int );

DIP_ERROR dip_AreaOpening     ( dip_Image, dip_Image, dip_Image, dip_int, dip_int,
                                dip_Boolean );
DIP_ERROR dip_PathOpening     ( dip_Image, dip_Image, dip_Image, dip_int, dip_Boolean,
                                dip_Boolean );
DIP_ERROR dip_DirectedPathOpening
                              ( dip_Image, dip_Image, dip_Image, dip_FloatArray,
                                dip_Boolean, dip_Boolean );

#endif /* !SWIG */

/* endif of DIP_MORPHOLOGY_H */
#ifdef __cplusplus
}
#endif
#endif
