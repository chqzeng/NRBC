/*
 * Filename: dip_restoration.h
 *
 * author: Geert van Kempen
 *
 */

#ifndef DIP_IM_RESTORATION_H
#define DIP_RESTORATION_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_transform.h"

typedef enum
{
	DIP_RESTORATION_VERBOSE = 1,
	DIP_RESTORATION_SYMMETRIC_PSF = 2,
	DIP_RESTORATION_OTF = 4,
	DIP_RESTORATION_SIEVE = 8,
	DIP_RESTORATION_NORMALIZE = 16,
	DIP_RESTORATION_USE_INPUTS = 32,
	DIP__RESTORATION_IN_FT = 256,
	DIP__RESTORATION_COPY_BACK = 512,
	DIP__RESTORATION_NO_NORMALIZATION = 1024
} dipf_ImageRestoration;

typedef enum
{
	DIP_RESTORATION_REG_PAR_MANUAL = 0,
	DIP_RESTORATION_REG_PAR_GCV = 1,
	DIP_RESTORATION_REG_PAR_CLS,
	DIP_RESTORATION_REG_PAR_SNR,
	DIP_RESTORATION_REG_PAR_EDF,
	DIP_RESTORATION_REG_PAR_ML,
	DIP_RESTORATION_REG_PAR_EDF_CV,
	DIP_RESTORATION_REG_PAR_CLS_CV,
	DIP_RESTORATION_REG_PAR_SNR_CV,
	DIP_RESTORATION_VARIANCE_CV
} dipf_RegularizationParameter;

/* support functions */
DIP_ERROR dip_RestorationTransform ( dip_Image, dip_Image,
											dipf_FourierTransform, dipf_ImageRestoration );

/* functions to determine the tikhonov regularization parameter */
DIP_ERROR dip_TikhonovRegularizationParameter ( dip_Image, dip_Image,
																dip_Image, dip_Image,
																dip_float, dip_float,
																dip_float *,
																dipf_RegularizationParameter,
																dip_float,
																dipf_ImageRestoration );

DIP_ERROR dip_TikhonovMiller ( dip_Image, dip_Image, dip_Image, dip_Image,
										 dip_Image, dipf_RegularizationParameter,
										 dip_float, dip_float *, dipf_ImageRestoration );

DIP_ERROR dip_Wiener ( dip_Image, dip_Image, dip_Image, dip_Image,
								dip_Image, dipf_ImageRestoration );

DIP_ERROR dip_PseudoInverse ( dip_Image, dip_Image, dip_Image, dip_float,
										dipf_ImageRestoration );


#ifdef __cplusplus
}
#endif
#endif
