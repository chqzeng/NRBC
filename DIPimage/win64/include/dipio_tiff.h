/*
 * Filename: dipio_tiff.h
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

#ifndef DIPIO_TIFF_H
#define DIPIO_TIFF_H

#ifdef __cplusplus
extern "C" {
#endif

DIPIO_EXPORT dip_int dipio_ReadTIFFID  ( void );
DIPIO_EXPORT dip_int dipio_WriteTIFFID ( void );

DIPIO_ERROR dipio_ImageReadTIFF        ( dip_Image, dip_String, dip_int,
                                         dipio_PhotometricInterpretation * );
DIPIO_ERROR dipio_ImageReadTIFFInfo    ( dipio_ImageFileInformation, dip_String, dip_int );
DIPIO_ERROR dipio_ImageIsTIFF          ( dip_String, dip_Boolean * );
DIPIO_ERROR dipio_ImageWriteTIFF       ( dip_Image, dip_String, dipio_PhotometricInterpretation,
                                         dip_PhysicalDimensions, dipio_Compression );


/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterReadTIFF( dip_int * );
dip_Error dipio_RegisterWriteTIFF( dip_int * );
dip_Error dipio_InitialiseTIFF( void );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_TIFF_H */
