/*
 * Filename: dip_interpolation.h
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

#ifndef DIP_INTERPOLATION_H
#define DIP_INTERPOLATION_H
#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
	DIP_INTERPOLATION_DEFAULT = 0,
	DIP_INTERPOLATION_BSPLINE = 1,
	DIP_INTERPOLATION_FOURTH_ORDER_CUBIC = 2,
	DIP_INTERPOLATION_THIRD_ORDER_CUBIC = 3,
	DIP_INTERPOLATION_LINEAR = 4,
	DIP_INTERPOLATION_ZERO_ORDER_HOLD = 5,
	DIP_INTERPOLATION_NEAREST_NEIGHBOUR,
   DIP_INTERPOLATION_LANCZOS_2,
   DIP_INTERPOLATION_LANCZOS_3,
   DIP_INTERPOLATION_LANCZOS_4,
   DIP_INTERPOLATION_LANCZOS_6,
   DIP_INTERPOLATION_LANCZOS_8,
} dipf_Interpolation;
#define DIP_INTERPOLATION_BILINEAR DIP_INTERPOLATION_LINEAR /* for backwards-compatability */

typedef enum
{
   DIP_BGV_DEFAULT             =  0,
   DIP_BGV_ZERO                =  1,
   DIP_BGV_MAX_VALUE           =  2,
   DIP_BGV_MIN_VALUE           =  3,
   DIP_BGV_MANUAL              =  4
} dip_BackgroundValue;

typedef enum
{
   DIP_ROT90_0 = 0,
   DIP_ROT90_90,
   DIP_ROT90_180,
   DIP_ROT90_270,
   DIP_ROT90_M90=DIP_ROT90_270
} dipf_Rotation90;

DIP_ERROR dip_Resampling ( dip_Image, dip_Image, dip_FloatArray,
		dip_FloatArray, dipf_Interpolation );
DIP_ERROR dip_ResampleAt ( dip_Image, dip_ImageArray,	dip_Image,
	   dipf_Interpolation, dip_float );
DIP_ERROR dip_Subsampling ( dip_Image, dip_Image, dip_IntegerArray );
DIP_ERROR dip_Skewing ( dip_Image, dip_Image, dip_float, dip_int, dip_int,
		dipf_Interpolation, dip_BackgroundValue, dip_Boolean );
DIP_ERROR dip_SkewingWithBgval ( dip_Image, dip_Image, dip_float, dip_int, dip_int,
		dipf_Interpolation, dip_BackgroundValue, dip_float, dip_Boolean );
DIP_ERROR dip_Rotation ( dip_Image, dip_Image, dip_float, dipf_Interpolation,
		dip_BackgroundValue );
DIP_ERROR dip_RotationWithBgval ( dip_Image, dip_Image, dip_float, dipf_Interpolation,
		dip_BackgroundValue, dip_float );      
DIP_ERROR dip_Rotation3d_Axis ( dip_Image, dip_Image, dip_float, dip_int, dipf_Interpolation,
		dip_BackgroundValue );
DIP_ERROR dip_Rotation3d ( dip_Image, dip_Image, dip_float, dip_float, dip_float, dipf_Interpolation,
		dip_BackgroundValue );
DIP_ERROR dip_Rotation2d90( dip_Image, dip_Image, dipf_Rotation90 );
DIP_ERROR dip_Rotation3d90( dip_Image, dip_Image, dip_int, dipf_Rotation90 );
/* for backwards-compatability */
#define dip_Rotation3dAxis(a,b,c,dim,e,f) dip_Rotation3d_Axis(a,b,c,dim-1,e,f)
#define dip_Rotation2D90(a,b,c) dip_Rotation2d90(a,b,c)
#define dip_Rotation3D90(a,b,dim,c) dip_Rotation3d90(a,b,dim-1,c)

DIP_ERROR dip_AffineTransform( dip_Image, dip_Image, dip_Image, dip_Image,
                               dip_IntegerArray, dip_IntegerArray );
DIP_ERROR dip_DetermineLineIntersection( dip_FloatArray, dip_FloatArray,
              dip_FloatArray, dip_FloatArray, dip_float *, dip_float *,
              dip_Boolean * );
#ifdef __cplusplus
}
#endif
#endif
