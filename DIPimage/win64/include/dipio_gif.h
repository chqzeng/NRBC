/*
 * Filename: dipio_gif.h
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

#ifndef DIPIO_GIF_H
#define DIPIO_GIF_H

#ifdef __cplusplus
extern "C" {
#endif


DIPIO_EXPORT dip_int dipio_ReadGIFID  ( void );
DIPIO_EXPORT dip_int dipio_WriteGIFID ( void );

DIPIO_ERROR dipio_ImageReadGIF      ( dip_Image, dip_String,
                                      dipio_PhotometricInterpretation * );
DIPIO_ERROR dipio_ImageReadGIFInfo ( dipio_ImageFileInformation, dip_String );
DIPIO_ERROR dipio_ImageIsGIF        ( dip_String, dip_Boolean * );
DIPIO_ERROR dipio_ImageWriteGIF     ( dip_Image, dip_String, dip_Boolean );
                                  
/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterReadGIF  ( dip_int * );
dip_Error dipio_RegisterWriteGIF ( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_GIF_H */
