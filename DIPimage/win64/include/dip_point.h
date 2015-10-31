/*
 * Filename: dip_point.h
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
 * author
 *    Geert M.P. van Kempen
 *
 */

#ifndef DIP_POINT_H
#define DIP_POINT_H
#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
	DIP_CLIP_DEFAULT             = 0, /* If neither DIP_CLIP_LOW or DIP_CLIP_HIGH */
	DIP_CLIP_LOW                 = 1, /* is specified, DIP_CLIP_BOTH is assumed.  */
	DIP_CLIP_HIGH                = 2,
	DIP_CLIP_BOTH                = (DIP_CLIP_LOW|DIP_CLIP_HIGH),
	DIP_CLIP_THRESHOLD_AND_RANGE = 4,
	DIP_CLIP_LOW_AND_HIGH_BOUNDS = 8
} dipf_Clip;

typedef enum
{
	DIP_CST_LINEAR             = 0,
	DIP_CST_SIGNED_LINEAR      = 1,
	DIP_CST_LOGARITHMIC        = 2,
	DIP_CST_SIGNED_LOGARITHMIC = 3,
	DIP_CST_ERF                = 4,
	DIP_CST_DECADE             = 5,
	DIP_CST_SIGMOID            = 6,
	DIP_CST_CLIP               = 7,
	DIP_CST_01                 = 8,
	DIP_CST_PI                 = 9
} dipf_ContrastStretch;


typedef enum
{
   DIP_RMAPOR_HALF_PI = 1,
   DIP_RMAPOR_PI      = 2,
   DIP_RMAPOR_2PI     = 3,
   DIP_RMAPOR_2PI_0   = 4
} dipf_RemapOrientation;

#ifndef SWIG

DIP_ERROR dip_Clip	( dip_Image, dip_Image, dip_float, dip_float, dipf_Clip );
DIP_ERROR dip_ErfClip( dip_Image, dip_Image, dip_float, dip_float, dipf_Clip );
DIP_ERROR dip_NotZero ( dip_Image, dip_Image );
DIP_ERROR dip_SelectValue ( dip_Image, dip_Image, dip_float );
DIP_ERROR dip_Threshold	( dip_Image, dip_Image, dip_float, dip_float, dip_float,
                          dip_Boolean );
DIP_ERROR dip_RangeThreshold	( dip_Image, dip_Image, dip_float, dip_float,
										dip_float, dip_float, dip_Boolean );

DIP_ERROR dip_ContrastStretch ( dip_Image, dip_Image, dip_float, dip_float,
									dip_float, dip_float, dipf_ContrastStretch,
									dip_float, dip_float, dip_float);

DIP_ERROR dip__ContrastStretch ( dip_Image, dip_Image, dip_float, dip_float,
									dip_float, dip_float, dipf_ContrastStretch,
									dip_float, dip_float, dip_float, dip_DataType);

DIP_ERROR dip_RemapOrientation( dip_Image, dip_Image, dipf_RemapOrientation );

DIP_ERROR dip_HysteresisThreshold(	dip_Image, dip_Image, dip_float, dip_float );


#endif /* !SWIG */

#ifdef __cplusplus
}
#endif
#endif
