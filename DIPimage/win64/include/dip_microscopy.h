/*
 * Filename: dip_microscopy.h
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
 *
 */

#ifndef DIP_MICROSCOPY_H
#define DIP_MICROSCOPY_H
#ifdef __cplusplus
extern "C" {
#endif

typedef enum
{
	DIP_MICROSCOPY_OTF_STOKSETH = 1,
	DIP_MICROSCOPY_OTF_HOPKINS  = 2
} dipf_IncoherentOTF;


#define DIP_MICROSCOPY_HOPKINS_OTF_CUTOFF 0.0001

DIP_ERROR dip_IncoherentPSF ( dip_Image, dip_float, dip_float );
DIP_ERROR dip_IncoherentOTF ( dip_Image, dip_float, dip_float, dip_float,
										dipf_IncoherentOTF );

typedef dip_float (*dip_IFunction)(dip_float, dip_float, dip_float, dip_float);


typedef enum
{
	DIP_ATTENUATION_EXP_FIT_DATA_DEFAULT = 0,
	DIP_ATTENUATION_EXP_FIT_DATA_MEAN = 0,
	DIP_ATTENUATION_EXP_FIT_DATA_PERCENTILE = 1
} dipf_ExpFitData;

typedef enum
{
	DIP_ATTENUATION_EXP_FIT_START_DEFAULT = 0,
	DIP_ATTENUATION_EXP_FIT_START_FIRST_PIXEL = 0,
	DIP_ATTENUATION_EXP_FIT_START_GLOBAL_MAXIMUM = 1,
	DIP_ATTENUATION_EXP_FIT_START_FIRST_MAXIMUM = 2
} dipf_ExpFitStart;

typedef enum
{
	DIP_ATTENUATION_RAC_LT2 = 0,
	DIP_ATTENUATION_RAC_LT1 = 1,
	DIP_ATTENUATION_RAC_DET = 2,
	DIP_ATTENUATION_DEFAULT = DIP_ATTENUATION_RAC_LT2
} dipf_AttenuationCorrection;


typedef struct
{
   dip_float x;
   dip_float y;
   dip_float z;
} dip__Vector2d;

typedef struct
{
	dip_int  MaxSub2Int;
	dip_int  ZMaxSub2Int;
	dip_float MaxSub2Double;
	dip_float ZMaxSub2Double;
	dip_float RayStep;
} dip__AttSimTrace;


DIP_ERROR dip_ExponentialFitCorrection ( dip_Image, dip_Image,
		dipf_ExpFitData, dip_float, dipf_ExpFitStart, dip_float, dip_Boolean );
DIP_ERROR dip_AttenuationCorrection ( dip_Image, dip_Image, dip_float,
	dip_float, dip_float, dip_float, dip_float, dip_float,
	dip_float, dipf_AttenuationCorrection );
DIP_ERROR dip_SimulatedAttenuation ( dip_Image, dip_Image, dip_float,
   dip_float, dip_float, dip_float, dip_float, dip_int, dip_float);

#define DIP_ATTENUATION_NORMALIZATION 100.0

#ifdef __cplusplus
}
#endif
#endif
