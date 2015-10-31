/*
 * Filename: dip_binary.h
 *
 * (C) Copyright 1995-1997               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIP_BINARY_H
#define DIP_BINARY_H
#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
	DIP_ENDPIXEL_CONDITION_LOOSE_ENDS_AWAY = -1,
	DIP_ENDPIXEL_CONDITION_NATURAL = 0,
	DIP_ENDPIXEL_CONDITION_KEEP_WITH_ONE_NEIGHBOR = 1,
	DIP_ENDPIXEL_CONDITION_KEEP_WITH_TWO_NEIGHBORS = 2,
	DIP_ENDPIXEL_CONDITION_KEEP_WITH_THREE_NEIGHBORS = 3
} dip_EndpixelCondition;


typedef enum
{
   DIP_UPPER_SKELETON_DUMMY
} dipf_UpperSkeleton;

#ifndef SWIG

DIP_ERROR dip_BinaryDilation ( dip_Image, dip_Image, dip_int, dip_int, dip_Boolean );
DIP_ERROR dip_BinaryErosion  ( dip_Image, dip_Image, dip_int, dip_int, dip_Boolean );
DIP_ERROR dip_BinaryClosing  ( dip_Image, dip_Image, dip_int, dip_int, dip_int );
DIP_ERROR dip_BinaryOpening  ( dip_Image, dip_Image, dip_int, dip_int, dip_int );
DIP_ERROR dip_BinaryPropagation  ( dip_Image, dip_Image, dip_Image, dip_int,
												dip_int, dip_Boolean );
DIP_ERROR dip_EdgeObjectsRemove ( dip_Image, dip_Image, dip_int );
DIP_ERROR dip_PlaneCopy      ( dip_Image, dip_int, dip_Image, dip_int );
DIP_ERROR dip_PlaneSet       ( dip_Image, dip_int );
DIP_ERROR dip_PlaneReset     ( dip_Image, dip_int );
DIP_ERROR dip_PlaneSetEdge   ( dip_Image, dip_int );
DIP_ERROR dip_PlaneResetEdge ( dip_Image, dip_int );

DIP_ERROR dip_EuclideanSkeleton ( dip_Image, dip_Image, dip_EndpixelCondition, dip_Boolean );
DIP_ERROR dip_BinarySkeleton3D  ( dip_Image, dip_Image, dip_EndpixelCondition, dip_Boolean );
DIP_ERROR dip_UpperSkeleton2D   ( dip_Image, dip_Image, dip_Image, dipf_UpperSkeleton );

const dip_uint8 *dip_GetHilditchTable ( void );
const dip_uint8 *dip_GetHilditchRecursiveTable ( void );

#endif /* !SWIG */

#ifdef __cplusplus
}
#endif
#endif
