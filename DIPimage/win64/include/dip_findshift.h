/*
 *
 * (C) Copyright 1995-1999               Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email  : lucas@ph.tn.tudelft.nl
 *
 * AUTHOR:
 *    Cris Luengo
 *
 */

#ifndef DIP_FINDSHIFT_H
#define DIP_FINDSHIFT_H
#ifdef __cplusplus
extern "C" {
#endif

#include "dip_linear.h"

typedef enum
{
	DIP_FSM_DEFAULT = 0x00, 
	DIP_FSM_XCORR,
   DIP_FSM_INTEGER_ONLY,
	DIP_FSM_CPF,
	DIP_FSM_MTS,
	DIP_FSM_FFTS = DIP_FSM_CPF,
	DIP_FSM_GRS = DIP_FSM_MTS, 
	DIP_FSM_ITER,
	DIP_FSM_PROJ,
	DIP_FSM_NCC
} dipf_FindShiftMethod;

DIP_ERROR dip_FindShift (dip_Image, dip_Image, dip_FloatArray,
								  dipf_FindShiftMethod, dip_float, dip_Image);

DIP_ERROR dip_CrossCorrelationFT (dip_Image, dip_Image, dip_Image,
											  dipf_ImageRepresentation,
											  dipf_ImageRepresentation,
											  dipf_ImageRepresentation);

#ifdef __cplusplus
}
#endif
#endif
