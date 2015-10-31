/*
 * Filename: dip_regions.h
 *
 * (C) Copyright 2004-2005               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * Author: Michael van Ginkel
 */

#ifndef DIP_REGIONS_H
#define DIP_REGIONS_H

#ifdef __cplusplus
extern "C" {
#endif

#define DIP_LB_LABEL_IS_SIZE       1
#define DIP_LB_THRESHOLD_ON_SIZE   2
#define DIP__LB_LARGEST_FLAG       3

#define DIP_RGCY_SEPARATORS               1
#define DIP_RGCY_SEPARATOR_LINKS          2
#define DIP_RGCY_REGIONS_DIRECTLY         4
#define DIP_RGCY_REGIONS_INDIRECTLY       8
#define DIP_RGCY_REGIONS_SEPARATE_LISTS  16
#define DIP_RGCY_ALLOW_SINGLE_NEIGHOURS  32

DIP_ERROR dip_Label          ( dip_Image, dip_Image, dip_int, dip_int,
                               dip_int, dip_int, dip_int *, dip_BoundaryArray );
DIP_ERROR dip_LabelSetBorder ( dip_Image, dip_Image );
DIP_ERROR dip_PlaneDoEdge    ( dip_Image, dip_int, dip_int );
DIP_ERROR dip_ImageDoEdge    ( dip_Image, dip_int );
DIP_ERROR dip_RegionConnectivity
                             ( dip_Image, dip_Image,
                               dip_sint32 ***, dip_sint32 ***,
                               dip_sint32 ***, dip_sint32 ***,
                               dip_int, dip_int, dip_int,
                               dip_int *, dip_int *, dip_int *,
                               dip_int *, dip_int *, dip_int *,
                               dip_BoundaryArray, dip_Resources );

DIP_ERROR dip_GrowRegions    ( dip_Image, dip_Image, dip_Image, dip_Image,
                               dip_int, dip_int, dipf_GreyValueSortOrder );
DIP_ERROR dip_GrowRegionsWeighted
                             ( dip_Image, dip_Image, dip_Image, dip_Image,
                               dip_Image, dip_FloatArray, dip_int, dip_Image );

#ifdef __cplusplus
}
#endif
#endif
