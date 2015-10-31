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

#ifndef DIPIO_PIC_H
#define DIPIO_PIC_H

#ifdef __cplusplus
extern "C" {
#endif


DIPIO_EXPORT dip_int dipio_ReadPICID  ( void );

DIPIO_ERROR dipio_ImageReadPIC     ( dip_Image, dip_String, dip_IntegerArray, dip_IntegerArray,
                                     dip_IntegerArray );
DIPIO_ERROR dipio_ImageReadPICInfo ( dipio_ImageFileInformation, dip_String );

/* should only be called by dipio_Initialise() */
dip_Error dipio_RegisterReadPIC ( dip_int * );

#ifdef __cplusplus
}
#endif


#endif /* DIPIO_PIC_H */
