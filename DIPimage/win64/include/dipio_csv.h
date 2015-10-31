/*
 * Filename: dipio_csv.h
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

#ifndef DIPIO_CSV_H
#define DIPIO_CSV_H

#ifdef __cplusplus
extern "C" {
#endif


DIPIO_EXPORT dip_int dipio_ReadCSVID  ( void );
DIPIO_EXPORT dip_int dipio_WriteCSVID ( void );

DIPIO_ERROR dipio_ImageReadCSV     ( dip_Image, dip_String, char );
DIPIO_ERROR dipio_ImageReadCSVInfo ( dipio_ImageFileInformation, dip_String, char );
DIPIO_ERROR dipio_ImageWriteCSV    ( dip_Image, dip_String, char );

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterReadCSV ( dip_int * );
dip_Error dipio_RegisterWriteCSV ( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_CSV_H */
