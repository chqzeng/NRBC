/*
 * Filename: dipio_pic.h
 *
 * (C) Copyright 2000                    Pattern Recognition Group
 *     All rights reserved               Faculty of Applied Physics
 *                                       Delft University of Technology
 *                                       Lorentzweg 1
 *                                       2628 CJ Delft
 *                                       The Netherlands
 *
 * Contact: Dr. ir. Lucas J. van Vliet
 * email : lucas@ph.tn.tudelft.nl
 *
 */

#ifndef DIPIO_PS_H
#define DIPIO_PS_H

#ifdef __cplusplus
extern "C" {
#endif

#define DIPIO_PAGE_WIDTH   20.0
#define DIPIO_PAGE_HEIGHT  27.0

DIPIO_EXPORT dip_int dipio_WritePSID  ( void );
DIPIO_EXPORT dip_int dipio_WriteEPSID ( void );

DIPIO_ERROR dipio_ImageWritePS  ( dip_Image, dip_String, dipio_PhotometricInterpretation,
                                  dip_String, dip_float, dip_float, dip_int );
DIPIO_ERROR dipio_ImageWriteEPS ( dip_Image, dip_String, dipio_PhotometricInterpretation,
                                  dip_float, dip_float, dip_int );

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterWritePS( dip_int * );
dip_Error dipio_RegisterWriteEPS( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_PS_H */
