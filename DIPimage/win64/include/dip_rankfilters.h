/*
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
 * Author: Geert M.P. van Kempen
 *
 */

#ifndef DIP_RANKFILTERS_H
#define DIP_RANKFILTERS_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_pixel_table.h"

typedef struct
{
   dip_float percentile;
   dip_int   size;
   void      *buffer;
} dip_PercFilterParams;


DIP_ERROR dip_PercentileFilter ( dip_Image, dip_Image, dip_Image,
		dip_BoundaryArray, dip_FloatArray, dip_FilterShape, dip_float );
DIP_ERROR dip_MedianFilter ( dip_Image, dip_Image, dip_Image,
		dip_BoundaryArray, dip_FloatArray, dip_FilterShape);
DIP_ERROR dip_RankContrastFilter ( dip_Image, dip_Image, dip_Image,
		dip_BoundaryArray, dip_FloatArray, dip_FilterShape, dip_Boolean );

#ifdef __cplusplus
}
#endif
#endif
