/*
 * Filename: dipio_lsm.h
 *
 * (C) Copyright 2000-2004               Pattern Recognition Group
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

#ifndef DIPIO_LSM_H
#define DIPIO_LSM_H

#ifdef __cplusplus
extern "C" {
#endif

DIPIO_EXPORT dip_int dipio_ReadLSMID  ( void );

DIPIO_ERROR dipio_ImageIsLSM          ( dip_String, dip_Boolean * );
DIPIO_ERROR dipio_ImageReadLSM        ( dip_Image, dip_String, dip_IntegerArray,
                                        dip_IntegerArray, dip_IntegerArray );
DIPIO_ERROR dipio_ImageReadLSMInfo    ( dipio_ImageFileInformation, dip_String );

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterReadLSM( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_TIFF_H */
