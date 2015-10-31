/*
 * Filename: dip_display.h
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

#ifndef DIP_DISPLAY_H
#define DIP_DISPLAY_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_point.h"
#include "dip_interpolation.h"

typedef enum
{
	DIP_DISPLAY_PROJECTION_SLICE   = 1,
	DIP_DISPLAY_PROJECTION_MAXIMUM = 2,
	DIP_DISPLAY_PROJECTION_MEAN    = 3
} dipf_DisplayProjection;

typedef enum
{
	DIP_DISPLAY_COMPLEX_MODULUS   = 1,
	DIP_DISPLAY_COMPLEX_PHASE     = 2,
	DIP_DISPLAY_COMPLEX_REAL      = 3,
	DIP_DISPLAY_COMPLEX_IMAGINARY = 4
} dipf_DisplayComplex;

typedef struct
{
	dipf_ContrastStretch   contrastStretch;
	dipf_DisplayComplex    complex;
	dipf_DisplayProjection projection;
	dipf_Interpolation     interpolation;
	dip_float              lowerBound;
	dip_float              upperBound;
	dip_float              sigmoidSlope;
	dip_float              sigmoidPoint;
	dip_float              maxDecade;
	dip_Boolean            globalMaxMin;
} dip_Display;

/* declaration of display functions */
DIP_ERROR dip_ImageDisplay ( dip_Image, dip_Image, dip_IntegerArray, dip_int,
								dip_int, dip_IntegerArray, dip_Display );
										
#ifdef __cplusplus
}
#endif
#endif
