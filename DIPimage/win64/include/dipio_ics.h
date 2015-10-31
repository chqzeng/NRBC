/*
 * Filename: dipio_ics.h
 *
 * (C) Copyright 2000-2005               Pattern Recognition Group
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

#ifndef DIPIO_ICS_H
#define DIPIO_ICS_H

#ifdef __cplusplus
extern "C" {
#endif

DIPIO_EXPORT dip_int dipio_ReadICSID    ( void );
DIPIO_EXPORT dip_int dipio_WriteICSv1ID ( void );
DIPIO_EXPORT dip_int dipio_WriteICSv2ID ( void );

DIPIO_ERROR dipio_ImageReadICS          ( dip_Image, dip_String, dipio_PhotometricInterpretation*,
                                          dip_IntegerArray, dip_IntegerArray, dip_IntegerArray );
DIPIO_ERROR dipio_ImageReadICSInfo      ( dipio_ImageFileInformation, dip_String );
DIPIO_ERROR dipio_ImageIsICS            ( dip_String, dip_Boolean * );
DIPIO_ERROR dipio_AppendRawData         ( dip_Image, dip_String );
DIPIO_ERROR dipio_ImageWriteICS         ( dip_Image, dip_String, dipio_PhotometricInterpretation,
                                          dip_PhysicalDimensions, dip_StringArray, dip_int, dip_int, dipio_Compression );

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterReadICS    ( dip_int * );
dip_Error dipio_RegisterWriteICSv1 ( dip_int * );
dip_Error dipio_RegisterWriteICSv2 ( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_ICS_H */
