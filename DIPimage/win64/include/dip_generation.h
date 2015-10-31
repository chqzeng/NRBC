/*
 * Filename: dip_generation.h
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

#ifndef DIP_GENERATION_H
#define DIP_GENERATION_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_noise.h"

typedef struct
{
	dip_float *origin;
	dip_float *scale;
	dip_float radius;
	dip_float amplitude;
	dip_float cutoff;
} dip_GenerationParams;

#define DIP_GENERATION_EXP_CUTOFF (-50.0)

DIP_ERROR dip_FTSphere		( dip_Image, dip_Image, dip_float, dip_float );
DIP_ERROR dip_FTBox			( dip_Image, dip_Image, dip_float, dip_FloatArray, dip_float);
DIP_ERROR dip_FTCube			( dip_Image, dip_Image, dip_float, dip_float );
DIP_ERROR dip_FTGaussian	( dip_Image, dip_Image, dip_FloatArray, dip_float, dip_float );
DIP_ERROR dip_FTEllipsoid	( dip_Image, dip_Image, dip_float, dip_FloatArray, dip_float);
DIP_ERROR dip_FTCross		( dip_Image, dip_Image, dip_float, dip_FloatArray, dip_float);

DIP_ERROR dip_EuclideanDistanceToPoint ( dip_Image, dip_FloatArray );
DIP_ERROR dip_EllipticDistanceToPoint  ( dip_Image, dip_FloatArray,
														dip_FloatArray );
DIP_ERROR dip_CityBlockDistanceToPoint ( dip_Image, dip_FloatArray,
														dip_FloatArray );
DIP_ERROR dip_GenerateRamp ( dip_Image, dip_DataType,
                             dip_IntegerArray, dip_int );


typedef enum
{
	DIP_TEST_OBJECT_ELLIPSOID = 1,
	DIP_TEST_OBJECT_BOX,
	DIP_TEST_OBJECT_ELLIPSOID_SHELL,
	DIP_TEST_OBJECT_BOX_SHELL,
	DIP_TEST_OBJECT_USER_SUPPLIED
} dipf_TestObject;

typedef enum
{
	DIP_TEST_PSF_GAUSSIAN = 1,
	DIP_TEST_PSF_INCOHERENT_OTF,
	DIP_TEST_PSF_USER_SUPPLIED,
	DIP_TEST_PSF_NONE
} dipf_TestPSF;

DIP_ERROR dip_TestObjectCreate ( dip_Image, dip_Image, dipf_TestObject,
									dip_float, dip_float, dip_FloatArray, dip_float,
									dip_float, dip_float, dip_Boolean, dip_Random * );

DIP_ERROR dip_TestObjectModulate ( dip_Image, dip_Image,
											dip_FloatArray, dip_float );

DIP_ERROR dip_TestObjectBlur ( dip_Image, dip_Image, dip_Image,
											dip_float, dipf_TestPSF );

DIP_ERROR dip_TestObjectAddNoise ( dip_Image, dip_Image, dip_Image,
											dip_float, dip_float, dip_float, dip_float,
											dip_float *, dip_float *, dip_Random * );

DIP_ERROR dip_ObjectCylinder  ( dip_Image, dip_float, dip_float,
										  dip_FloatArray, dip_FloatArray, dip_float );
DIP_ERROR dip_ObjectEdge      ( dip_Image, dip_float, dip_float,
										  dip_FloatArray, dip_FloatArray, dip_float );
DIP_ERROR dip_ObjectPlane     ( dip_Image, dip_float, dip_float,
										  dip_FloatArray, dip_FloatArray, dip_float );
DIP_ERROR dip_ObjectEllipsoid ( dip_Image, dip_float, dip_FloatArray, dip_float,
										  dip_FloatArray, dip_FloatArray, dip_float );

dip_Error dip__RotateEuler ( dip_FloatArray, dip_FloatArray, dip_FloatArray );

#ifdef __cplusplus
}
#endif
#endif
