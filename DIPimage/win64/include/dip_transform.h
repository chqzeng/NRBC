/*
 * Filename: dip_transform.h
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
 *
 * General definitions and prototypes for the dip_transform library.
 *
 * AUTHOR
 *    Michael van Ginkel
 *
 * HISTORY
 *    7 November 1995     - MvG - created
 */

#ifndef DIP_TPI_INC

#ifndef DIP_TRANSFORM_H
#define DIP_TRANSFORM_H
#ifdef __cplusplus
extern "C" {
#endif


typedef enum
{
   DIP_TR_FORWARD =         0x0001,
   DIP_TR_INVERSE =         0x0002,
   DIP__TR_MASK_DIRECTION = 0x0003,

   DIP_TR_SPATIAL_SHIFT =   0x0004,
   DIP_TR_FREQUENCY_SHIFT = 0x0008,
   DIP_TR_SHIFT =           0x000C,
   DIP__TR_MASK_SHIFT =     0x000C,
   DIP__TR_INPUT_SHIFT =    0x0004,
   DIP__TR_OUTPUT_SHIFT =   0x0008,

   DIP_TR_NO_GOOD =         0x0010,
   DIP_TR_NO_COOLEY_TUKEY = 0x0020,
   DIP_TR_NO_WINOGRAD =     0x0040,

   DIP_TR_NO_INPUT_PERMUTATION =  0x0080,
   DIP_TR_NO_OUTPUT_PERMUTATION = 0x0100,
   DIP_TR_DONT_PERMUTE =          0x0180,

   DIP_TR_TMP                      = 0x0200,
   DIP_TR_I_WILL_COPY              = 0x0400,
   DIP_TR_MASK_FLAGS               = 0x05F3
} dipf_FourierTransform;

/* NOT USED (CL)
typedef struct
{
   int dummy;
} dip_FourierState;
*/

typedef void *dip_FourierTransformInfo;
typedef void *dip_HartleyTransformInfo;


DIP_ERROR dip_FourierTransform ( dip_Image, dip_Image, dipf_FourierTransform,
                                 dip_BooleanArray, void * );
DIP_ERROR dip_HartleyTransform ( dip_Image, dip_Image, dipf_FourierTransform,
                                       dip_BooleanArray );
DIP_ERROR dip_FourierTransformInfoNew ( dip_FourierTransformInfo *,
                                        dip_DataType, dip_int,
                                        dipf_FourierTransform, dip_Resources );
DIP_ERROR dip_HartleyTransformInfoNew ( dip_HartleyTransformInfo *,
                                        dip_DataType, dip_int,
                                        dipf_FourierTransform, dip_Resources );
DIP_ERROR dip_FourierTransformInfoHandler ( void * );
DIP_ERROR dip_HartleyTransformInfoHandler ( void * );


#define DIP_TPI_INC_ALLOW DIP_DTGID_FLOAT|DIP_DTGID_COMPLEX
#define DIP_TPI_INC_FILE "dip_transform.h"
#include "dip_tpi_inc.h"
#ifdef __cplusplus
}
#endif

#endif

#else

#if ( DIP_TPI_INC_IDENTIFIER & DIP_DTGID_COMPLEX )
   DIP_TPI_INC_DECLARE(dip_FourierTransform1d) ( void *, void *,
                                              dip_FourierTransformInfo );
#endif

#if ( DIP_TPI_INC_IDENTIFIER & DIP_DTGID_FLOAT )
   DIP_TPI_INC_DECLARE(dip_HartleyTransform1d)
                    ( void *, void *, void *, void *,
                      dip_HartleyTransformInfo );
#endif

#endif
