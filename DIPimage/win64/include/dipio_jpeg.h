/*
 *
 * (C) Copyright 2006                    Lawrence Berkeley National Lab
 *     All rights reserved               One Cyclotron Road - Mailstop 84-171
 *                                       Berkeley, CA 94709
 *                                       USA
 *
 * Author: Cris Luengo
 *
 */

#ifndef DIPIO_JPEG_H
#define DIPIO_JPEG_H

#ifdef __cplusplus
extern "C" {
#endif

DIPIO_EXPORT dip_int dipio_ReadJPEGID  ( void );
DIPIO_EXPORT dip_int dipio_WriteJPEGID ( void );

DIPIO_ERROR dipio_ImageReadJPEG        ( dip_Image, dip_String,
                                         dipio_PhotometricInterpretation * );
DIPIO_ERROR dipio_ImageReadJPEGInfo    ( dipio_ImageFileInformation, dip_String );
DIPIO_ERROR dipio_ImageIsJPEG          ( dip_String, dip_Boolean * );
DIPIO_ERROR dipio_ImageWriteJPEG       ( dip_Image, dip_String, dipio_PhotometricInterpretation,
                                         dip_PhysicalDimensions, dip_uint );

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterReadJPEG( dip_int * );
dip_Error dipio_RegisterWriteJPEG( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_JPEG_H */
