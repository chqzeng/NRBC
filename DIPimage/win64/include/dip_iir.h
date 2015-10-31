/*
 * Filename: dip_iir.h
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
 *
 */

#ifndef DIP_IIR_H
#define DIP_IIR_H
#ifdef __cplusplus
extern "C" {
#endif

DIP_ERROR dip_GaussIIR ( dip_Image, dip_Image, dip_BoundaryArray,
								dip_BooleanArray, dip_FloatArray, dip_IntegerArray,
								dip_IntegerArray, dip_int, dip_float );

DIP_ERROR dip_GaborIIR ( dip_Image, dip_Image, dip_BoundaryArray,
								dip_BooleanArray, dip_FloatArray, dip_FloatArray,
								dip_IntegerArray, dip_float );

#ifdef __cplusplus
}
#endif
#endif
